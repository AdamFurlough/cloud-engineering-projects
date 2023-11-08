# Install AWS Distro for OpenTelemetry (ADOT) as RPM


## Links
- [how to install collector as rpm](https://aws-otel.github.io/docs/setup/build-collector-as-rpm)
- [how to set up config file](https://opentelemetry.io/docs/collector/configuration/)


## Install

Note: downloaded from s3, can also clone from github but not sure if this would be available in NBIS environment?

**Install from s3**
- update ```sudo yum -y update```
- install wget ```sudo yum install wget```
- download rpm from s3 ```wget https://aws-otel-collector.s3.amazonaws.com/amazon_linux/amd64/latest/aws-otel-collector.rpm```
- install ```sudo rpm -Uvh ./aws-otel-collector.rpm```

**Prepare config file**
- prepare yaml config file with desired receivers and exporters

**Start Collector**
- start adot ```sudo /opt/aws/aws-otel-collector/bin/aws-otel-collector-ctl -c /tmp/config.yaml -a start```

    Note: 
    - if config.yaml is not supplied, service will use default, can pull config file from local </path/config.yaml>, or S3 uri <s3://bucket/config>
    - if config.yaml file is invalid then service will not start

**Additional actions**
- check status ```sudo /opt/aws/aws-otel-collector/bin/aws-otel-collector-ctl -a status```
- stop ```sudo /opt/aws/aws-otel-collector/bin/aws-otel-collector-ctl -a stop```


## Terraform
- draft script for install via terraform
- include as user data in resource definition of desired ec2
- be sure to add s3 uri or other config.yaml location before use

```
  user_data = <<-EOF
              #!/bin/bash
              yum -y update
              yum -y install wget
              wget https://aws-otel-collector.s3.amazonaws.com/amazon_linux/amd64/latest/aws-otel-collector.rpm
              rpm -Uvh ./aws-otel-collector.rpm
              /opt/aws/aws-otel-collector/bin/aws-otel-collector-ctl -c <s3://bucket/config.yaml> -a start

              EOF
```
