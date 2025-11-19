#!/bin/bash

echo "Deploying to Staging Org..."
sf deploy metadata --source-dir force-app/main/default --target-org digital-marketing-staging

if [ $? -eq 0 ]; then
    echo "Deployment to Staging Org completed successfully!"
else
    echo "Deployment to Staging Org failed!"
    exit 1
fi
