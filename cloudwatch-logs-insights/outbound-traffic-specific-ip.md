# CloudWatch Log Insight - Lookup Outbound Connections

## Purpose

Lists recent outbound traffic from an EC2 instance (identified by source IP matching 10.50.x.x), including source/destination IPs and ports, action taken (ACCEPT or REJECT), and ENI used.

## When to Use

- You're investigating whether your instance attempted outbound connections.
- You want to see the ENI associated with the traffic.
- You want to confirm if traffic is being rejected or accepted at the VPC Flow Logs level.

## Log Group Type

Outbound Traffic from Specific Instance (By ENI or IP)

## Query

```sql
fields @timestamp as timestamp, interfaceId as eni
| sort @timestamp desc
| limit 10000
| display timestamp, srcAddr, srcPort, dstAddr, dstPort, action, eni
| filter srcAddr like '10.50'
```
