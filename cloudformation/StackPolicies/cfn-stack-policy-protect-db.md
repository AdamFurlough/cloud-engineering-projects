# Example CloudFormation Stack Policies

These example stack policies both protect a "ProductionDatabase" resource.

Example 1 uses two statements, the first to allow all and the second to deny the resource that we want to protect.

```json
{
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : "Update:*",
      "Principal": "*",
      "Resource" : "*"
    },
    {
      "Effect" : "Deny",
      "Action" : "Update:*",
      "Principal": "*",
      "Resource" : "LogicalResourceId/ProductionDatabase"
    }
  ]
}
```

Example 2 uses `"NotResource"` and achieves the same logical result as above but more concise.

```json
{
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : "Update:*",
      "Principal": "*",
      "NotResource" : "LogicalResourceId/ProductionDatabase"
    }
  ]
}
```