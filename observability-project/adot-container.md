# Observability Project - Step 3 - ADOT container

The AWS Distro for OpenTelemetry (ADOT) provides a Docker container image that allows users to collect and send telemetry data, such as metrics and traces, to various backends, including AWS CloudWatch, X-Ray, and Amazon Managed Service for Prometheus. To use the ADOT Collector in a Docker container, you can pull the official image from the Amazon ECR Public Gallery or other container registries

- [AWS GitHub](https://github.com/aws-observability/aws-otel-collector/blob/main/docs/developers/docker-demo.md)
- [AWS Docs](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-ingest-metrics-OpenTelemetry-ECS.html)

## Run Commands

```
sudo docker pull amazon/aws-otel-collector
docker run -d --rm -p 4317:4317 -p 55680-55681:55680-55681 -p 8888:8888 -p 9411:9411 -p 9080:9080 -v /home/ec2-user/config.yaml:/otel-local-config.yaml --name awscollector amazon/aws-otel-collector
```
