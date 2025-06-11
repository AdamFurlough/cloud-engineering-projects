# AWS CLI Bash Scripts

These scripts are a quick, one-off way to pull info from AWS or execute recurring actions.  Long-term automation should be created as Python Lambda functions with EventBridge invocation.

## SSO Profile

Before using the bash scripts, you will need to set up an AWS SSO profile to use your AWS IAM Identity Center role from the CLI.


### Create Profile Using wizard
- Start wizard with: `aws configure sso`
- Follow prompts to set values for this profile:
    - SSO start URL: (example) `https://start.home.awsapps.com/directory/d-123412341234`
    - SSO region: us-west-1
    - Select account from list
    - Select role from list
    - CLI default client Region: us-west-1
    - Leave 'CLI default output format' to default for json or specify text output
    - Leave 'CLI profile name' to default for

### To Use Profile

- Specify the profile name when running aws cli commands using --profile
- Example: `aws s3 ls --profile admin-111122223333`

### Get New Token

- Tokens expire every 4 hours
- To get a new token use: `aws sso login --profile admin-111122223333`
- Note that this is specific to each profile so you will have to run it for each profile you want to use
