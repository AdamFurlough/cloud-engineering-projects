#!/bin/bash

# Output file where the list of all IAM actions will be saved
OUTPUT_FILE="all-iam-actions-$(date +'%Y-%m-%d').txt"

# Run curl command to fetch the policies.js content
curl --header 'Connection: keep-alive' \
     --header 'Pragma: no-cache' \
     --header 'Cache-Control: no-cache' \
     --header 'Accept: */*' \
     --header 'Referer: https://awspolicygen.s3.amazonaws.com/policygen.html' \
     --header 'Accept-Language: en-US,en;q=0.9' \
     --silent \
     --compressed \
     'https://awspolicygen.s3.amazonaws.com/js/policies.js' | \
    # Process the output using cut and jq to extract and format IAM actions
    cut -d= -f2 | \
    jq -r '.serviceMap[] | .StringPrefix as $prefix | .Actions[] | "\($prefix):\(.)"' | \
    # Sort and remove duplicates
    sort | \
    uniq > "$OUTPUT_FILE"

# Output message
echo "The IAM actions have been saved to $OUTPUT_FILE"