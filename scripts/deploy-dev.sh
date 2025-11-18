#!/bin/bash

# Deploy script for development environment
echo "Starting deployment to development environment..."

# Check if Salesforce CLI is installed
if ! command -v sfdx &> /dev/null
then
    echo "Salesforce CLI is not installed. Please install it first."
    exit 1
fi

# Authenticate to Dev Hub (if not already authenticated)
echo "Authenticating to Dev Hub..."
sfdx force:auth:web:login -d -r https://test.salesforce.com

# Deploy to development org
echo "Deploying to development org..."
sfdx force:source:deploy -p force-app -u dev-org

# Run tests
echo "Running tests..."
sfdx force:apex:test:run -u dev-org

echo "Deployment to development environment completed successfully!"
