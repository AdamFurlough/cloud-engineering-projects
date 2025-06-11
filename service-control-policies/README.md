# Service Control Policies

SCPs are used within the AWS Organizations service to set guardrails for your AWS accounts by denying specific IAM actions at the OU level.  This directory contains helpful snippits for construction SCP policies and a simple CloudFormation template for deploying with a transform/include to pull in the JSON policy file.

See the [AWS docs](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html) for more info.