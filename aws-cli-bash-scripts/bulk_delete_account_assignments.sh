#!/bin/bash 
 
# Set aws sso profile to use for authentication
PROFILE="role-name-111122223333"
 
# Set permission set and group that should be deleted in the target accounts 
PERMISSION_SET_ARN="arn:aws:sso:::permissionSet/ssoins-123412341234/ps-123412341234" 
PRINCIPAL_ID="12341234-1234-1234-1234-123412341234" 
 
# List of all AWS account numbers where the assignment should be deleted, add or remove accounts as needed 
AWS_ACCOUNTS=("111111111111" "222222222222") 
 
# Instance arn will be the same for the entire org 
INSTANCE_ARN="arn:aws:sso:::instance/ssoins-123412341234" 
 
# Types will be the same for all group account assignments 
PRINCIPAL_TYPE="GROUP" 
TARGET_TYPE="AWS_ACCOUNT" 
 
# Loop through each account number and perform the delete-account-assignment action 
for ACCOUNT_ID in "${AWS_ACCOUNTS[@]}"; do 
  echo "Processing AWS Account: $ACCOUNT_ID" 
   
  # Execute AWS CLI command 
  aws sso-admin delete-account-assignment \ 
    --profile "$PROFILE" \
    --instance-arn "$INSTANCE_ARN" \ 
    --permission-set-arn "$PERMISSION_SET_ARN" \ 
    --principal-id "$PRINCIPAL_ID" \ 
    --principal-type "$PRINCIPAL_TYPE" \ 
    --target-id "$ACCOUNT_ID" \ 
    --target-type "$TARGET_TYPE"

  if [[ $? -eq 0 ]]; then 
    echo "Successfully deleted account assignment for account $ACCOUNT_ID" 
  else 
    echo "Failed to delete account assignment for account $ACCOUNT_ID" 
  fi 
   
done