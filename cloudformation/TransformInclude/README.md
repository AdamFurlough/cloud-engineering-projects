# CloudFormation - Transform Include Feature

This helpful feature of CloudFormation can be used to pull external files into the mail template.  For example, IAM policies can be stored as JSON and pulled into a YAML cfn template.  This method preserves the syntax highlighting of both files for easier readability and copy/past of the JSON IAM statements to and from the AWS console.

See the [official AWS documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/transform-aws-include.html) for more info.

The transform function is used with the type 'AWS::Include'.

```yaml
        'Fn::Transform':
          Name: 'AWS::Include'
          Parameters:
            Location: !Ref PolicyPath
```

Example using PermissionSet resource type:

```yaml
Resources:
  PermissionSet:
    Type: AWS::SSO::PermissionSet
    Properties:
      Name: !Ref PermissionSetName
      Description: !Ref PermissionSetName
      InstanceArn: !Ref SsoInstanceArn
      SessionDuration: 'PT4H'
      ManagedPolicies:
        - arn:aws:iam::aws:policy/ReadOnlyAccess
      InlinePolicy:
        'Fn::Transform':
          Name: 'AWS::Include'
          Parameters:
            Location: !Ref PolicyPath
```