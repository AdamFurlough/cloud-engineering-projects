# Install
Great tutorial I followed: https://www.youtube.com/watch?v=SLB_c_ayRMo&list=WL&index=2
* Download from https://www.terraform.io/
* Extract exe from zip
* Create new folder in C “Terraform”       C:\Terraform
* Edit system environment variables, 
  * search “env”
  * “Edit system environment variables”
  * “environment variables”
  * Select “path”
  * “Edit”
  * “New”
  * Paste in “C:\Terraform”
* In terminal “terraform -v”    to test that install worked
* Install VScode, install Terraform Hashicorp official extension
* Create a directory to store code

# Creating a Simple One-Instance Script
Great tutorial I followed: https://www.youtube.com/watch?v=SLB_c_ayRMo&list=WL&index=2
* Use VScode to create main.tf in the project directory
* List AWS as the provider
* Reference provider instructions: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
`$ terraform init`
`$ terraform plan`
`$ terraform apply`         (enter yes to approve)
`$ terraform destroy`      (when done to clean up)

# Best Practices
Great instructional video I made these notes from: https://www.youtube.com/watch?v=gxPykhPxRW0&list=WL&index=1
  1. Manipulate state only through TF commands
  2. Remote State
  3. State Locking
  4. Back up State File
  5. Use 1 State per Environment
  6. Host TF code in Git repository
  7. CI for TF Code 
  8. Execute TF only in an automated build

# Commands
Great instructional video I made these notes from: https://www.youtube.com/watch?v=l5k1ai_GBDE
* Refresh - queries infrastructure provider (AWS) to get current state, updates state file
* Plan - core compares configuration file with state file to determine execution plan (like a preview)
* Apply - executes the plan, changes infrastructure as needed to achieve the desired state
* Destroy - cleans up all the resources

