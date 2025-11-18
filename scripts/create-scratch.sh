#!/bin/bash

# Script to create a new scratch org
echo "Creating new scratch org..."

# Check if Salesforce CLI is installed
if ! command -v sfdx &> /dev/null
then
    echo "Salesforce CLI is not installed. Please install it first."
    exit 1
fi

# Create scratch org
echo "Creating scratch org from dev definition..."
sfdx force:org:create -f config/dev-scratch-def.json -a dev-org -d 30

# Assign permission set
echo "Assigning permission set..."
sfdx force:user:permset:assign -n DigitalMarketingDeveloper

# Open org
echo "Opening org..."
sfdx force:org:open -u dev-org

echo "Scratch org created successfully!"
