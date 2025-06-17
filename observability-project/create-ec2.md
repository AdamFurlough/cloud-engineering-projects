# Observability Project - Step 1 - Create and Configure EC2

## Goal

Create rhel8 ec2 with iam role to opensearch

## Cloudformation

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: CloudFormation template for RHEL 8 EC2 instance with IAM role for sending logs to OpenSearch.

Parameters:
  KeyName:
    Description: Name of an existing EC2 KeyPair to enable SSH access to the instance.
    Type: AWS::EC2::KeyPair::KeyName
    ConstraintDescription: Must be the name of an existing EC2 KeyPair.
  InstanceType:
    Description: WebServer EC2 instance type (e.g., t3.medium, t3.large).
    Type: String
    Default: t3.medium
    AllowedValues:
      - t3.micro
      - t3.small
      - t3.medium
      - t3.large
      - m5.large
      - m5.xlarge
    ConstraintDescription: Please choose a valid instance type.
  SSHLocation:
    Description: The IP address range that can be used to SSH into the EC2 instance.
    Type: String
    MinLength: 9
    MaxLength: 18
    Default: 0.0.0.0/0
    AllowedPattern: "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
    ConstraintDescription: Must be a valid IP CIDR range of the form x.x.x.x/x.
  OpenSearchDomainARN:
    Description: The ARN of your Amazon OpenSearch Service domain (e.g., arn:aws:es:REGION:ACCOUNT_ID:domain/DOMAIN_NAME).
    Type: String
    MinLength: 20
    ConstraintDescription: Please provide a valid OpenSearch Domain ARN.

Resources:
  EC2InstanceIAMRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - ec2.amazonaws.com
            Action:
              - sts:AssumeRole
      Path: /
      ManagedPolicyArns:
        # Policy for CloudWatch Logs (Fluent Bit often sends logs here first or uses it for logging its own state)
        - arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy # This policy grants permissions for CloudWatch Agent, which is generally sufficient for basic log publishing to CloudWatch Logs.
      Policies:
        - PolicyName: OpenSearchLogAccessPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  # These actions are commonly needed by ADOT/Fluent Bit to send data to OpenSearch
                  - es:ESHttpPost
                  - es:ESHttpPut
                  - es:ESHttpDelete
                  - es:ESHttpGet
                  - es:ESHttpPatch
                Resource: !Sub "${OpenSearchDomainARN}/*" # Grants access to the domain and its indexes.
              - Effect: Allow
                Action:
                  - es:DescribeDomain
                  - es:ListDomainNames
                Resource: !Sub "${OpenSearchDomainARN}" # Grants permission to describe the OpenSearch domain

  EC2InstanceIAMInstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Path: /
      Roles:
        - !Ref EC2InstanceIAMRole

  EC2SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable SSH access
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: !Ref SSHLocation
      Tags:
        - Key: Name
          Value: !Sub "${AWS::StackName}-SecurityGroup"

  RHEL8EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: "AMI_ID_PLACEHOLDER" # IMPORTANT: Replace with a valid RHEL 8 HVM AMI ID for your region (e.g., ami-0abcdef1234567890 for us-east-1). Find it in the EC2 console or by searching for 'RHEL-8' AMIs owned by '309956199498'.
      InstanceType: !Ref InstanceType
      KeyName: !Ref KeyName
      IamInstanceProfile: !Ref EC2InstanceIAMInstanceProfile
      SecurityGroupIds:
        - !GetAtt EC2SecurityGroup.GroupId
      Tags:
        - Key: Name
          Value: !Sub "${AWS::StackName}-RHEL8-EC2"
      UserData:
        Fn::Base64: |
          #!/bin/bash -xe
          # Update system
          sudo yum update -y
          # Install Docker
          sudo yum install -y docker
          # Start and enable Docker service
          sudo systemctl start docker
          sudo systemctl enable docker
          # Add ec2-user to the docker group
          sudo usermod -aG docker ec2-user
          # Install git (useful for cloning repos with container configs)
          sudo yum install -y git
          echo "Docker installed and configured. EC2 instance is ready for container deployment."

Outputs:
  InstanceId:
    Description: The ID of the EC2 instance
    Value: !Ref RHEL8EC2Instance
  PublicIp:
    Description: The Public IP address of the EC2 instance
    Value: !GetAtt RHEL8EC2Instance.PublicIp
  PublicDnsName:
    Description: The Public DNS name of the EC2 instance
    Value: !GetAtt RHEL8EC2Instance.PublicDnsName
```

