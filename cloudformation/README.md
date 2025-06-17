## CloudFormation

## Introduction

AWS CloudFormation is an Infrastructure as Code (IaC) tool used for deployment of cloud resources. Templates will be written in YAML with the file extension .yaml and must be saved in a central, shared location such as a git repo or S3 bucket with versioning. Nested stacks will be used with standard child templates whenever possible to promote consistency in the deployment of resources.

The AWS Serverless Application Model (SAM) is an extension of CloudFormation. Its syntax may be used in parallel with AWS CloudFormation syntax within the same template.

## Code Repositories

To align with general best practices for Infrastructure as Code IaC should be stored in a central location with versioning.

## AWS Code Commit

AWS Code Commit is a deprecated service that is no longer accepting new customers.

- Exported AWS SSO credentials can be used to authenticate to clone Code Commit repos.
- Instructions in AWS Documentation

### 1. Edit AWS Config

Open the aws config file located within `C:\Users\<UserName>\.aws\config`
Ensure the following defaults are set:

```
.aws/config 
[default]
region = us-west-1
output = json
```

### 2. Edit Git Bash Config

Open the git config file located within `C:\Users\<UserName>\.gitconfig`
Ensure the following defaults are set:

```
.gitconfig 
[credential]     
helper = !aws codecommit credential-helper $@   
UseHttpPath = true  
```

### 3. Export Credentials

- Open the AWS Access Portal (ADFS Landing Page)
- Click "Access keys" next to a role that has permissions to code commit
- from MacOS & Linux Tab, follow the instructions for "Option 1: Set AWS environment variables"

### 4. Clone the Code Commit Repo

cd to the desired folder and run: `git clone <repo-url>`
- If prompted for username/password via a pop-up windown, click "cancel"
- This will force git to use the credentials you exported in the previous step to login to CodeCommit
- It may provide an error message of "fatal: User cancelled the authentication prompt" but should still successfully clone the repo

For troubleshooting use: `GIT_CURL_VERBOSE=1 GIT_TRACE=1 git clone <repo-url>`

## S3 Bucket

S3 storage is convenient for CloudFormation templates because the S3 url of the template file can be used in the AWS console when deploying or updating stacks. The AWS CLI can be used with SSO profiles to sync templates from workspaces VS Code to S3 similar to a git push.  Before using the below sync commands, you will need to Setup AWS CLI with SSO Profiles.
Sync to S3 bucket using SSO Profile

To pull from or push to IaC templates to S3, the s3 sync command can be used
- Usage: `aws s3 sync <bucket> <localDirectory>`

Note that the s3 sync commands without additional options will not delete removed files
- The delete option --delete must be added for the sync to delete files as part of the sync
- Please exercise caution when using this option
- Usage: `aws s3 sync <localDirectory> <bucket> --delete`

## CloudFormation Template Contents

### Linting Standards

All CloudFormation templates should be linted using a tool such as cfn-lint. This ensures syntactic correctness and validates against AWS best practices. Linting should be incorporated into CI pipelines to enforce quality gates before deployment.

### VS Code Extensions

Recommended VS Code extensions for working with CloudFormation:

- AWS Toolkit (easy editing of files in S3)
- AWS CloudFormation (official AWS extension)
- YAML Language Support
- cfn-lint integration
- Prettier for consistent formatting

### AWS Style Guides & Example Templates

Refer to the AWS CloudFormation Best Practices and the AWS Samples GitHub repository for style and structure guidance. Examples should follow modular, reusable, and parameterized patterns.
Comments and README Files

•	Every template must include comments to explain complex logic and parameter usage.
•	A README.md should be present in each IaC repo, providing:
o	Overview of the stack
o	Deployment instructions
o	Links to design discussions or documentation
o	Change log summary

### Comments

Parameters should be commented to explain:
•	Why the parameter is needed
•	Allowed values or constraints
•	Default values and their rationale

### Descriptions in CloudFormation

Use the Description field on templates, parameters, resources, and outputs to enhance clarity. This improves both maintainability.
SIDs in JSON Policy Documents
Use meaningful Sid entries to describe the intent of policy statements. These aid in policy troubleshooting and governance reviews.
 
### Readmes

Document:
•	Purpose of the template
•	Parameters and default values
•	Outputs and dependencies
•	Links to documentation, RFCs, or ADRs that guided decisions

### Avoid Breaking Links

•	Use relative paths within a repo when referencing nested templates.
•	If referencing S3 URLs, ensure paths are versioned or tagged to prevent breaking changes.

### Nested Template URLs

Use S3 URIs for nested templates and IAM policies. Ensure they are:

- Publicly readable if cross-account deployment is needed
- Versioned using S3 object versioning or consistent prefixes
- S3 URI File Paths for JSON Policies
 
Store reusable IAM policies in an S3 bucket with:

- Clear naming conventions (iam/policies/role-xyz-policy.json)
- Version control via prefixes or object versioning
- Restricted access where necessary using bucket policies

### Resource Naming

Follow consistent patterns across all resources:

- Use camelCase or kebab-case as appropriate per resource type
-	Avoid underscores (_) where AWS disallows them (e.g., S3 bucket names)
Resource Name Constraints
-	Follow service-specific max length rules (AWS Resource Limits)
-	Avoid including environment or account-specific info unless necessary
-	Consider name collision risks in global namespaces (e.g., IAM roles)

### Resource Tagging

Tag all resources using standard tagging practices defined in the [Tagging Guidance Document]. Tags should include:

- Name
- Environment
- Owner
- CostCenter
- Application

### Parameters

Use Transform: AWS::Include to insert external JSON policy documents or templates when needed. This helps:

-	Simplify templates
-	Improve reuse and maintainability
-	Reduce duplication

### Code Review

A senior engineer should verify:

-	Template correctness and logical accuracy
-	Reuse of parameters and outputs across stacks
-	That best practices are followed (modularity, least privilege, naming conventions)
-	Proper handling of IAM roles and permissions

Common Breakage Points

-	Adding required parameters to templates in active use (can break existing deployments)
-	Changing logical IDs (causes resource replacement)
-	Incorrect DependsOn or missing dependencies
-	Hard-coded ARNs or region-specific values

### File Structure

Naming Conventions

-	File and folder names: use kebab-case (e.g., user-role-stack.yaml)
-	Consistent suffixes for file types: *-role.yaml, *-policy.json
-	Stack folders should include relevant context: networking/, iam/, compute/

Capitalization 

-	File and folder names: lowercase only
-	Logical IDs in CloudFormation: CamelCase (e.g., MyLambdaRole)

### Standard Templates

Use of Nested Stacks

-	Use nested stacks to encapsulate reusable components
-	Child templates should be parameterized and version-controlled
-	Reference using S3 URLs: `TemplateURL: https://s3.amazonaws.com/my-bucket/templates/my-template.yaml`
-	Avoid adding required parameters to templates in active use—this can break production deployments

## Deployment

Deployment Models

- Stacks - For isolated use cases or app-specific deployments
- StackSets - from management account or delegated CloudFormation admin account

Permisisons Model

- Service-managed is a simplified way to deploy stackset but it will not work when deploying nested stacksets.  If your template contains nested stacks you must use Self-Managed instead.
- Self-managed deployment uses IAM that you manually select. 
