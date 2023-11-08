# Install Kinesis Agent

##
- written in java and higher memory usage than fluent bit
- didn't find a way to send metrics, only logs in testing
- comparison of Kinesis Agent and fluent bit https://github.com/aws/aws-for-fluent-bit/issues/104

## Links
- official AWS documentation
    https://docs.aws.amazon.com/firehose/latest/dev/writing-with-agents.html

- example config on github
    https://github.com/awslabs/amazon-kinesis-agent/blob/master/configuration/example/agent.json


## Install Steps

- install from amazon provided s3 bucket
    ```sudo yum install -y https://s3.amazonaws.com/streaming-data-agent/aws-kinesis-agent-latest.amzn2.noarch.rpm```

- open config file
    ```sudo vi /etc/aws-kinesis/agent.json```

- set config to something like this example (edit region in firehose.enpoint and name in deliveryStream before use)
    ```
   {
      "cloudwatch.emitMetrics": false,
      "firehose.endpoint": "https://firehose.us-east-1.amazonaws.com",
      "flows": [
        {
          "filePattern": "/tmp/testlogs/*.log",
          "deliveryStream": "adams-delivery-stream"
        }
      ]
    }
    ```

- start service
    ```sudo service aws-kinesis-agent start```

- read logs to troubleshoot if needed
    ```tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log```

- if you get errors make changes to config as needed and restart
    ```sudo service aws-kinesis-agent restart```
