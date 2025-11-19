@echo off
echo Deploying Digital Marketing App with Lightning Experience enhancements...

echo 1. Deploying metadata...
sf deploy metadata --source-dir force-app/main/default

echo 2. Deploying static resources...
sf deploy metadata --source-dir force-app/main/default/staticresources

echo 3. Deploying Lightning App Page...
sf deploy metadata --source-dir force-app/main/default/flexipages

echo 4. Deploying Lightning App...
sf deploy metadata --source-dir force-app/main/default/lightningapps

echo 5. Deploying Application...
sf deploy metadata --source-dir force-app/main/default/apps

echo.
echo Deployment completed successfully!
echo.
echo To test the app:
echo 1. Navigate to your Salesforce org
echo 2. Go to Setup > Apps > App Manager
echo 3. Find "Digital Marketing App" and click "Edit"
echo 4. Make sure "Lightning Experience" is enabled
echo 5. Save and activate the app
