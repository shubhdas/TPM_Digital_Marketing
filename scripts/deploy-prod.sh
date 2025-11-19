#!/bin/bash

echo "Deploying to Production Org..."
sf deploy metadata --source-dir force-app/main/default --target-org digital-marketing-prod

if [ $? -eq 0 ]; then
    echo "Deployment to Production Org completed successfully!"
else
    echo "Deployment to Production Org failed!"
    exit 1
fi
