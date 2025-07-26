# CloudWatch Log Insight - Lookup Outbound Connections

## Purpose

Confirms that traffic is leaving the instance at all — useful to rule out firewall, OS, or app-level issues.

## Log Group Type

EC2 OS logs `/var/log/messages` or `/var/log/cloud-init.log`

## Query

```sql
fields @timestamp, srcAddr, dstAddr, dstPort, protocol, action
| filter srcAddr like '10.50.'
| sort @timestamp desc
| limit 100
```
