#!/bin/bash

# Update
sudo yum update -y

# Install nodejs, npm, zip, unzip, jq
sudo yum install nodejs npm zip unzip jq -y

# Install elasticdump
sudo npm install elasticdump -g

# Install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Purge aws directory and zip file
rm -r aws
rm awscliv2.zip

echo "Done!"
