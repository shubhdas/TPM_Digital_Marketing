#!/bin/bash

# Deploy script for staging environment
echo "Starting deployment to staging environment..."

# Check if Salesforce CLI is installed
if ! command -v sfdx &> /dev/null
then
    echo "Salesforce CLI is not installed. Please install it first."
    exit 1
fi

# Authenticate to Dev Hub (if not already authenticated)
echo "Authenticating to Dev Hub..."
sfdx force:auth:web:login -d -r https://test.salesforce.com

# Deploy to staging org
echo "Deploying to staging org..."
sfdx force:source:deploy -p force-app -u staging-org

# Run tests
echo "Running tests..."
sfdx force:apex:test:run -u staging-org

echo "Deployment to staging environment completed successfully!"
