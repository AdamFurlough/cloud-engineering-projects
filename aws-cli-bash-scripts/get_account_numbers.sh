#!/bin/bash

# Set aws sso profile to use for authentication
PROFILE="role-name-111122223333"

# Output file where the formatted group information will be saved
OUTPUT_FILE="aws-accounts-$(date +'%Y-%m-%d').txt"

# Use AWS CLI to get the list of Identity Center groups
aws organizations list-accounts --profile $PROFILE --output text | awk '{print $7 " " $4}' | sort -k1,1 >> "$OUTPUT_FILE" 

# Notify the user
echo "Accounts list has been written to $OUTPUT_FILE"