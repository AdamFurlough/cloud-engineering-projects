# CloudFormation Termination Protection

You can prevent a stack from being accidentally deleted by enabling termination protection on the stack. If a user attempts to delete a stack with termination protection enabled, the deletion fails and the stack, including its status, remains unchanged. You can enable termination protection on a stack when you create it. Termination protection on stacks is disabled by default. 

[AWS Doc "using-cfn-protect-stacks"](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-protect-stacks.html)

## Example Implementation

IAM policy to allow a user to modify termination protection

```json
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect":"Allow",
        "Action":[
            "cloudformation:UpdateTerminationProtection"
        ],
        "Resource":"*"
    }]
}
```

SCP to deny modifying termination protection except for a specific IAM Identity Center role "admin"

```json
{
    "Version":"2012-10-17",
    "Statement":{
        "Effect":"Deny",
        "Action":"cloudformation:UpdateTerminationProtection",
        "Resource":"*",
        "Condition": {
            "StringNotLike": {
                "aws:PrincipalARN": [
                    "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/us-west-1/AWSReservedSSO_admin_*"
                ]
            }
        }
    }
}
```