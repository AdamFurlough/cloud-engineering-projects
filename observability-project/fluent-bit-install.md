# Fluent Bit Install and Configuration

**Goal:** Install Fluent Bit on a RHEL 8 EC2 instance and configure it to send metrics and logs to AWS Kinesis Firehose. We'll be using an IAM role for secure authentication, which prevents the need to store access keys on the EC2 instance.

**Helpful links:**
* Fluent Bit documentation https://docs.fluentbit.io/manual


## Prerequisite Steps: 
* Create an IAM role for EC2 instance granting kinesis firehose access (I used "AmazonKinesisFirehoseFullAccess" but production should probably be more restricted)
* Attach to your instance


## Install Fluent Bit

* Install yum-utils 
* (yum-builddep: installs all the dependencies needed to build a given package)
```
sudo yum install -y yum-utils
```

* Add the official Fluent Bit repository:
```
sudo tee /etc/yum.repos.d/td-agent-bit.repo << EOL
[td-agent-bit]
name = TD Agent Bit
baseurl = https://packages.fluentbit.io/centos/8/\$basearch/
gpgcheck=1
gpgkey=https://packages.fluentbit.io/fluentbit.key
enabled=1
EOL
```

* Install Fluent Bit:
```
sudo yum install -y td-agent-bit
```

* Enable and start the Fluent Bit service:
```
sudo systemctl enable td-agent-bit
sudo systemctl start td-agent-bit
```


## Configuration File

* Create a backup of the original Fluent Bit configuration file:
```
sudo cp /etc/td-agent-bit/td-agent-bit.conf /etc/td-agent-bit/td-agent-bit.conf.bak
```

* Edit the Fluent Bit configuration file:
```
sudo vi /etc/td-agent-bit/td-agent-bit.conf
```

* Add the following to the end of your configuration file:
```
    # AWS Authentication
    # ==================
    # forces use of an attached role instead of the credentials file
    Environment AWS_SHARED_CREDENTIALS_FILE=/nonexistent

[INPUT]
    Name            cpu
    Tag             cpu.usage
    Interval_Sec    5

[INPUT]
    Name            mem
    Tag             mem.usage
    Interval_Sec    5

[INPUT]
    Name            disk
    Tag             disk.usage
    Interval_Sec    5

[INPUT]
   Name            tail
   Path            /tmp/testlog

[OUTPUT]
   name  stdout
   match *

[OUTPUT]
    Name kinesis_firehose
    Match *
    region us-east-1
    delivery_stream adams-delivery-stream
```
* The first block of text above forces Fluent Bit to authenticate using an IAM role instead of looking for the ```~/.aws/credentials``` file
* Be sure to replace place holders above with real info including the Path to the logs you want to capture
* Fluent Bit is very sensitive to indents. Make sure that indents are exactly 4 spaces and not tabs or any other hidden formatting.


## Restart and verify

* Restart the Fluent Bit service to apply the new configuration:
    ```sudo systemctl restart td-agent-bit```
* Check the status of the Fluent Bit service to ensure it is running without errors:
    ```sudo systemctl status td-agent-bit```
* If you get errors, you can try running Fluent Bit in the foreground with verbose output to get more detailed information about what might be going wrong:
    ```/opt/td-agent-bit/bin/td-agent-bit -c /etc/td-agent-bit/td-agent-bit.conf -v```
* Once the service is running successfully can check from AWS console in **Amazon Kinesis > Data Firehose > Monitoring > Incoming bytes** to see that data is being received
