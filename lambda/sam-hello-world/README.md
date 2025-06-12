# AWS SAM Python Lambda Project

## Project Structure

```
.
├── README.md
├── samconfig.toml
├── template.yaml
└── src
    └── hello_world
        ├── __init__.py
        └── app.py
```

## Prerequisites

- AWS SAM CLI
- AWS CLI
- Python 3.12
- An AWS account with appropriate permissions

## Local Development

1. Validate SAM template

```bash
sam validate
```

2. Build the application

```bash
sam build
```

3. Test locally

```bash
sam local invoke HelloWorldFunction -e events/event.json
sam local start-api
```

## Deployment Steps

1. Configure AWS credentials

```bash
aws configure
```

2. Deploy the application

```bash
sam deploy --guided
```
- This will create a new CloudFormation stack
- Follow the prompts to configure deployment parameters

## Testing the Deployed Lambda

- Use AWS Console or AWS CLI to invoke the function
- Test the API Gateway endpoint created by SAM

## Cleanup

```bash
sam delete
```
