# CloudWatch Log Insight - Filter for Rejected Traffic from an Instance

## Purpose

Shows if the traffic from your instance is being blocked, either by security group, NACL, or routing issue.

## Log Group Type

Log group should contain network traffic from the private IP or ENI of the EC2 instance

## Query

```
fields @timestamp as timestamp, interfaceId as eni, srcAddr, dstAddr, dstPort, protocol, action
| filter srcAddr like '10.50.' and action = 'REJECT'
| sort @timestamp desc
| limit 100
```
