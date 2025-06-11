#!/bin/bash

# Set aws sso profile to use for authentication
PROFILE="role-name-111122223333"

# Find IdentityStoreId using 'aws sso-admin list-instances'
IDENTITY_STORE_ID="d-1234abcd1234"

# Output file where the formatted group information will be saved
OUTPUT_FILE="idc-groups-$(date +'%Y-%m-%d').txt"

# Use AWS CLI to get the list of Identity Center groups

# Output to text
aws identitystore list-groups --profile $PROFILE --identity-store-id $IDENTITY_STORE_ID --output text | awk '{print $2, $3}' | sort -k1,1 >> "$OUTPUT_FILE"

# Alternate Output to json (remember to change file extension)
# aws identitystore list-groups --profile $PROFILE --identity-store-id "$IDENTITY_STORE_ID" >> "$OUTPUT_FILE"

# Notify the user
echo "Group information has been written to $OUTPUT_FILE"