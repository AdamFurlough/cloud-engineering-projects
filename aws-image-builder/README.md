# AWS Image Builder

- Image Builder is a fully managed orchestrator that creates an AMI from recipes
- It provisions temporary EC2 instances on your behalf to build the image
- A pipeline is the complete process used to create a specific image
- You define a pipeline with:
    - **Source image** (e.g., Amazon Linux 2)
    - **Components** (like hardening scripts or software installs)
    - **Target** (AMI or container)
- You can edit a pipeline to upgrade the recipe it uses to create the image to a newer version

## Key Elements

- **Recipes** are a collection of components used to build a complete image
- **Components** are a document containing commands to run on the build instance and can be from AWS, third-party market place, custom owned by this account, or shared from a different account 
- **Steps** are the order of operations of the pipeline, each step can use multiple components

## Tips

- set instance size used for the temporary instance created in "infrastructure configuration" of the pipeline

## Glossary

**AMI** - Amazon Machine Image
**Components** - are a document containing commands to run on the build instance and can be from AWS, third-party market place, custom owned by this account, or shared from a different account 
**Recipes** - collection of components used to build a complete image, can be from AWS, third-party market place, custom owned by this account, shared from a different account
**Source image** - the starting image that the recipe is then applied to (e.g., Amazon Linux 2 or RHEL9)
**Steps** - are the order of operations of the pipeline, each step can use multiple components
**Target** - the final output of a pipeline (AMI or container)
**TOE** - Target Operating Environment
