# CloudFormation Nested Stack Templates

These templates allow easy deployment of resources by just filling a list of parameters for a nested stack.  When deployed the parameters are passed through to the child templates and the resource is created with consistent settings, naming convention, and tagging.

The `NestedStackTemplates.yaml` file contains the templates for creating the nested stack resource for each resource type.  To use, copy the block for the resource you want to create into a new template and fill in the parameters as commented.  If you're not sure about a parameter, the child templates contain more detailed instructions for each parameter.