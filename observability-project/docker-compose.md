# Docker Compose Option for installing agent containers

- This doc contains all files needed to standup three docker containers for collection of logs, metrics, and traces for the opensearch project
- It is designed for RHEL 8
- Each of the three container's folders hold configuration files for that container and also their own READMEs specific to that application

## usage

1. copy all directories and files onto your EC2
2. run "install.sh" to remove podman conflicts and install docker
3. edit config files if needed to point to the correct opensearch endpoint
4. run "docker compose up -d" from within the main directory

## notes

- fluentbit is currently commented out to test jvm monitoring

# install docker-compose

```bash
#!/bin/bash
sudo yum -y update

# remove podman conflicts (can't install docker on rhel because of conflict with pre-installed podman)
sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine \
    podman \
    runc
 
# install docker (be sure to use centos NOT rhel in baseurl)
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  
# start docker
sudo systemctl start docker
sudo systemctl enable docker
```

# run docker-compose

```yaml
version: '3'
services:

  dataprepper:
    container_name: data-prepper
    image: opendistroforelasticsearch/data-prepper:latest
    volumes:
      - /home/ec2-user/otel-collector/opentelemetry-javaagent.jar:/opt/opentelemetry-javaagent.jar   # pass in otel java agent
      - /home/ec2-user/data-prepper/pipelines.yaml:/usr/share/data-prepper/data_prepper.yaml
    command: ["sh", "-c", "java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -jar /opt/opentelemetry-javaagent.jar"]
    ports:
      - "21890:21890" # default port
      - "9999:9999" # JMX port
    environment:
      - OTEL_SERVICE_NAME=data-prepper
      - OTEL_METRICS_EXPORTER=otlp
      - OTEL_TRACES_EXPORTER=otlp
      - OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

  otel-collector:
    container_name: otel-collector
    image: public.ecr.aws/aws-observability/aws-otel-collector:latest
    volumes:
      - ./otel-collector/config.yaml:/etc/otel/config.yamk
    ports:
      - "4317:4317"

#  fluentbit:
#    container_name: otel-collector
#    image: fluent/fluent-bit:latest
#    volumes:
#      - ./fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf
#    ports:
#      - "24224:24224"
#      - "24224:24224/udp"
```

# fluentbit

- fluentbit is used for log collection in this project
- see this link for more info: [Fluent Bit documentation](https://docs.fluentbit.io/manual)

## About the configuration files
- Fluent bit requires /etc/td-agent-bit/td-agent-bit.conf be provided at startup
- Note that a line is included to force fluentbit to use an IAM role instead of looking for the "~/.aws/credentials" 
    - "Environment AWS_SHARED_CREDENTIALS_FILE=/nonexistent"
- Fluent Bit yaml file is very sensitive to indents. Make sure that indents are exactly 4 spaces and not tabs or any other hidden formatting

## fluentbit.conf
```
[SERVICE]
    # Flush
    # =====
    # set an interval of seconds before to flush records to a destination
    flush        1

    # Daemon
    # ======
    # instruct Fluent Bit to run in foreground or background mode.
    daemon       Off

    # Log_Level
    # =========
    # Set the verbosity level of the service, values can be:
    #
    # - error
    # - warning
    # - info
    # - debug
    # - trace
    #
    # by default 'info' is set, that means it includes 'error' and 'warning'.
    log_level    info

    # Parsers File
    # ============
    # specify an optional 'Parsers' configuration file
    parsers_file parsers.conf

    # Plugins File
    # ============
    # specify an optional 'Plugins' configuration file to load external plugins.
    plugins_file plugins.conf

    # HTTP Server
    # ===========
    # Enable/Disable the built-in HTTP Server for metrics
    http_server  Off
    http_listen  0.0.0.0
    http_port    2020

    # Storage
    # =======
    # Fluent Bit can use memory and filesystem buffering based mechanisms
    #
    # - https://docs.fluentbit.io/manual/administration/buffering-and-storage
    #
    # storage metrics
    # ---------------
    # publish storage pipeline metrics in '/api/v1/storage'. The metrics are
    # exported only if the 'http_server' option is enabled.
    #
    storage.metrics on

    # storage.path
    # ------------
    # absolute file system path to store filesystem data buffers (chunks).
    #
    # storage.path /tmp/storage

    # storage.sync
    # ------------
    # configure the synchronization mode used to store the data into the
    # filesystem. It can take the values normal or full.
    #
    # storage.sync normal

    # storage.checksum
    # ----------------
    # enable the data integrity check when writing and reading data from the
    # filesystem. The storage layer uses the CRC32 algorithm.
    #
    # storage.checksum off

    # storage.backlog.mem_limit
    # -------------------------
    # if storage.path is set, Fluent Bit will look for data chunks that were
    # not delivered and are still in the storage layer, these are called
    # backlog data. This option configure a hint of maximum value of memory
    # to use when processing these records.
    #
    # storage.backlog.mem_limit 5M
    
    # AWS Authentication
    # ==================
    # forces use of an attached role instead of the credentials file
    Environment AWS_SHARED_CREDENTIALS_FILE=/nonexistent

[SERVICE]
    Flush     5
    Daemon    off
    Log_Level info
    Parsers_File parsers.conf

[INPUT]
    Name            tail
    Path            /var/log/*.log
    Parser          syslog
    Mem_Buf_Limit   5MB
    Skip_Long_Lines On
    Refresh_Interval 10
    Tag             syslog

[OUTPUT]
    Name                http
    Match               *
    Host                localhost    # double check that this format is right
    Port                21890   # Port 21890 is the default port exposed by Data Prepper
    Format              json
    Retry_Limit         False
```

## parsers.conf

```
[PARSER]
    Name        syslog
    Format      regex
    Regex       ^\<(?<pri>[0-9]+)\>(?<time>[A-Za-z0-9 :]+) (?<host>[a-zA-Z0-9\.]+) (?<ident>[a-zA-Z0-9\/\.\-]+)(?:\[(?<pid>[0-9]+)\])?[^\:]*\: (?<message>.*)$
    Time_Key    time
    Time_Format %b %d %H:%M:%S
```

# dataprepper

## Description

- A last mile data collector within the opensearch umbrella
- supports the 3 major signals in observability: trace, log, metric and can filter, enrich, transform, normalize data
- stateful processing, can hold onto data and aggregate it before forwarding

## Configuration files

- pipelines.yaml, map to ________ within the container

## Links

- https://opensearch.org/docs/latest/data-prepper/getting-started/
- https://opensearch.ossez.com/monitoring-plugins/trace/data-prepper-reference/
- https://stackoverflow.com/questions/74859874/data-prepper-pipelines-opensearch-trace-analytics
- [data prepper download](https://opensearch.org/downloads.html)
- [data prepper config reference guide](https://opensearch.org/docs/latest/data-prepper/managing-data-prepper/configuring-data-prepper/)
- https://opensearch.org/docs/latest/data-prepper/index/
- https://opendistro.github.io/for-elasticsearch-docs/docs/trace/data-prepper/
- https://forum.opensearch.org/c/data-prepper/61
- https://github.com/opensearch-project/data-prepper/blob/main/docs/getting_started.md

## pipelines.yaml

```yaml
metrics-pipeline:
  source:
    otel_metrics_source:
  processor:
    - otel_metrics_raw_processor:
  sink:
    - opensearch:
      hosts: ["https://localhost:9200"]
      username: admin
      password: admin
```

# otel collector

- OpenTelemetry (OTEL) is standard convention for observability (data format and API)
- ADOT (AWS Distro for OpenTelemetry) is a downstream distro of OpenTelemetry

## Config files
- config.yaml
    - There are 3 required sections (although there are other extensions and plugins that can also be used)
        - receivers (endpoints exposed for applications to send data to, port, protocol, etc.)
        - exporters (logging, loglevel)
        - service (pipelines, metrics, traces)

## Links

documentation
- [AWS Distro for OpenTelemetry Page](https://aws.amazon.com/otel/)
- [ADOT github](https://github.com/aws-observability/aws-otel-collector/blob/v0.30.0/README.md)

videos
- [Build On AWS Series](https://www.youtube.com/watch?v=XvmicNH_4lc&list=PLDqi6CuDzubz5viRapQ049TjJMOCCu9MJ&index=1)
- [David Venable and Rajiv Taori, Using Data Prepper for Observability Ingest-OpenSearchCon](https://www.youtube.com/watch?v=M3Ffpg_1nBE)
- [Video, full stack obsevability on AWS](https://catalog.workshops.aws/observability/en-US/intro#full-stack-observability-on-aws)
- [Video, Set up AWS Distro for OpenTelemetry Collector](https://youtu.be/837NtV0McOA)

articles
- [Getting started with aws distro for otel and dotnet, from "my tech ramblings"](https://www.mytechramblings.com/postsgetting-started-with-aws-distro-for-otel-and-dotnet-part-1/)
- [What is OpenTelemetry? Article](https://opentelemetry.io/docs/what-is-opentelemetry/)
- [Building a distributed tracing pipeline with OpenTelemetry Collector, Data Prepper, and OpenSearch Trace Analytics](https://opensearch.org/blog/distributed-tracing-pipeline-with-opentelemetry/)
- [Metrics Ingestion with Data Prepper using OpenTelemetry](https://opensearch.org/blog/opentelemetry-metrics-for-data-prepper/)

### java Agent

- [java auto instrumentation](https://opentelemetry.io/docs/instrumentation/java/automatic/)
- [JVM agent](https://github.com/open-telemetry/opentelemetry-java-instrumentation#getting-started)
- [agent configuration, OTLP is just one of the options](https://opentelemetry.io/docs/instrumentation/java/automatic/agent-config/)
- [video tutorial of including java agent in docker-compose, timestamp 5:04 for docker environment variables](https://www.youtube.com/watch?v=-lEsDNMs-QA)
- [configuration of agent, ie. "OTEL_TRACES_EXPORTER=otlp"](https://github.com/open-telemetry/opentelemetry-java/blob/main/sdk-extensions/autoconfigure/README.md#otlp-exporter-span-metric-and-log-exporters)
- [java sample app](https://github.com/aws-observability/aws-otel-community/tree/master/sample-apps/java-sample-app)

get agent jar onto EC2

```bash
curl https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar -o ~/opensearch-project/otel-collector/opentelemetry-javaagent.jar
```

```bash
JAVA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
```

## otel collector config file "config.yaml"

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: localhost:4317
      http:
        endpoint: localhost:4318

  jmx:
   jar_path: /opt/opentelemetry-java-contrib-jmx-metrics.jar
   endpoint: localhost:9000
   target_system: jvm
   collection_interval: 60s
   properties:
     # Attribute 'endpoint' will be used for generic_node's node_id field.
     otel.resource.attributes: endpoint=localhost:9000

processors:
  batch:
  resourcedetection:
    detectors: ["system"]
    system:
      hostname_sources: ["os"]

exporters:
  otlp/data-prepper:
     # Port 21890 is the default port exposed by Data Prepper
    endpoint: localhost:21890

service:
  pipelines:
    metrics:
      receivers:
      - jmx
      processors:
      - resourcedetection
      - resourceattributetransposer
      - resource
      - batch
      exporters: [otlp/data-prepper]

# COMMENTED OUT TO TEST JVM MONITORING      
#    traces:
#      receivers: [otlp]
#      processors: [batch]
#      exporters: [otlp/data-prepper]
#    metrics:
#      receivers: [otlp]
#      processors: [batch]
#      exporters: [otlp/data-prepper]
```
