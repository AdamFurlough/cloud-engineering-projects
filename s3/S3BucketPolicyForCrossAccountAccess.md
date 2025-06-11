# S3 Bucket Policy for Cross-account Sync

## Description:

- This policy allows aws s3 sync from one bucket to another
- Policy must be on both buckets with ARN for each bucket matching itself
- Ensure Principal ARN matches the SSO profile you will be using

## CLI commands used for Sandbox test:

`aws sso login --profile RoleName`
`aws s3 sync s3://BucketName1 s3://BucketName2 --profile RoleName`

## Bucket Policy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::111111111111:role/aws-reserved/sso.amazonaws.com/us-gov-west-1/AWSReservedSSO_RoleName_1234123412341234",   // set ARN to SSO role you will use
                    "arn:aws:iam::222222222222:role/aws-reserved/sso.amazonaws.com/us-gov-west-1/AWSReservedSSO_RoleName_1234123412341234"
                ]
            },
            "Action": [
                "s3:GetLifecycleConfiguration",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::BucketName",   // bucket ARN
                "arn:aws:s3:::BucketName/*"   // object ARN
            ]
        }
    ]
}
```