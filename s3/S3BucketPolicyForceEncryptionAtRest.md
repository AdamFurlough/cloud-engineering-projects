# S3 Bucket Policy - Force Encryption for Uploaded Objects

## SSE-KMS

This bucket policy forces SSE-KMS for new object uploads.  Change the resource ARN to the name of your s3 bucket.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Force KMS encryption for object upload",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::BucketName/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "aws:kms"
                }
            }
        }
    ]
}
```

## SSE-C

This bucket policy forces SSE-C for new object uploads.  Change the resource ARN to the name of your s3 bucket.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Force SSE-C encryption for object upload",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::BucketName/*",
            "Condition": {
                "Null": {
                    "s3:x-amz-server-side-encryption-customer-algorithm": "true"
                }
            }
        }
    ]
}
```