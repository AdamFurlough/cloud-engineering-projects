# S3 Bucket Policy to Force Encryption In Transit

This policy will deny any object downloads not using HTTPS.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Prevent downloads without encryption in transit",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::BucketName/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
```