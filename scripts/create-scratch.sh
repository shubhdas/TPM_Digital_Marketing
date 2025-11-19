#!/bin/bash

echo "Creating new scratch org..."
sf org create scratch --definition-file config/dev-scratch-def.json --alias digital-marketing-dev --set-default-org

if [ $? -eq 0 ]; then
    echo "Scratch org created successfully!"
    echo "Deploying metadata..."
    sf deploy metadata --source-dir force-app/main/default --target-org digital-marketing-dev
    
    if [ $? -eq 0 ]; then
        echo "Metadata deployed successfully!"
        echo "Opening scratch org..."
        sf org open --target-org digital-marketing-dev
    else
        echo "Failed to deploy metadata!"
        exit 1
    fi
else
    echo "Failed to create scratch org!"
    exit 1
fi
