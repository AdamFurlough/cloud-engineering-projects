# CloudWatch Log Insight - Check for DNS resolution failurese

## Purpose

Verifies if DNS resolution was failing (e.g., NXDOMAIN, SERVFAIL), which can block external connections even when network routing is fine.

## Log Group Type

Log group should contain network traffic from the private IP or ENI of the EC2 instance

## Query

```sql
fields @timestamp, queryName, responseCode, srcAddr
| filter responseCode != 'NOERROR' and srcAddr like '10.50.'
| sort @timestamp desc
| limit 100
```
