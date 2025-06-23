# GitLab CI/CD

Requires that the GitLab runner EC2 IAM role have this policy attached so that it can validate the CloudFormation template in the validate stage and assume the execution role in the deploy stage.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ValidateTemplates",
            "Effect": "Allow",
            "Action": "cloudformation:ValidateTemplate",
            "Resource": "*"
        },
        {
            "Sid": "AssumeExecutionRole",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::111122223333:role/gitlab-cicd-execution-role"
        }
    ]
}
```

The IAM role "gitlab-cicd-execution-role" will need these policies attached:

- `arn:aws:iam::aws:policy/AWSCloudFormationFullAccess`
- `arn:aws:iam::aws:policy/AmazonS3FullAccess` (or whatever service the pipeline is deploying via cloudformation)

Note that `grep` is used to parse the returned credentials json object because `jq` is not available in the `amazon/aws-cli` docker image