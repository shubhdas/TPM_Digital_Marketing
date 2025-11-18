#!/bin/bash

# Deploy script for production environment
echo "Starting deployment to production environment..."

# Check if Salesforce CLI is installed
if ! command -v sfdx &> /dev/null
then
    echo "Salesforce CLI is not installed. Please install it first."
    exit 1
fi

# Authenticate to Dev Hub (if not already authenticated)
echo "Authenticating to Dev Hub..."
sfdx force:auth:web:login -d -r https://test.salesforce.com

# Deploy to production org
echo "Deploying to production org..."
sfdx force:source:deploy -p force-app -u prod-org

# Run tests
echo "Running tests..."
sfdx force:apex:test:run -u prod-org

echo "Deployment to production environment completed successfully!"
