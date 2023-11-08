created rhel8 ec2 with iam role to opensearch

## install docker
sudo yum -y update
sudo yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce --nobest -y
sudo systemctl start docker
sudo systemctl enable docker

## run adot container
sudo docker pull amazon/aws-otel-collector
docker run -d --rm -p 4317:4317 -p 55680-55681:55680-55681 -p 8888:8888 -p 9411:9411 -p 9080:9080 -v /home/ec2-user/config.yaml:/otel-local-config.yaml --name awscollector amazon/aws-otel-collector

## run fluentbit container
docker pull cr.fluentbit.io/fluent/fluent-bit:2.0
docker run -d --rm -v /path/to/your/fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf --name fluentbit cr.fluentbit.io/fluent/fluent-bit:2.0
