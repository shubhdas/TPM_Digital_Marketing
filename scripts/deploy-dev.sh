#!/bin/bash

echo "Deploying to Development Org..."
sf deploy metadata --source-dir force-app/main/default --target-org digital-marketing-dev

if [ $? -eq 0 ]; then
    echo "Deployment to Development Org completed successfully!"
else
    echo "Deployment to Development Org failed!"
    exit 1
fi
