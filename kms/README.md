# KMS Key Policies

## kms-key-policy-allow-grants-for-aws-services

This KMS key policy can be used with:
- EBS and EC2 to attach an encrypted EBS volume to an EC2 instance.
- Redshift to launch and encrypted cluster
- AWS services integrated with AWS KMS that use grants to create, manage, or use encrypted resources with those services

## kms-key-policy-cross-account-access

Use to allow cross-account access to the key. The principle list is the other account that will use the key (not the account the key is in).
