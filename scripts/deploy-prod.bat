@echo off
REM Deploy script for production environment

echo Starting deployment to production environment...

REM Check if Salesforce CLI is installed
where sfdx >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Salesforce CLI is not installed. Please install it first.
    pause
    exit /b 1
)

REM Authenticate to Dev Hub (if not already authenticated)
echo Authenticating to Dev Hub...
sfdx force:auth:web:login -d -r https://test.salesforce.com

REM Deploy to production org
echo Deploying to production org...
sfdx force:source:deploy -p force-app -u prod-org

REM Run tests
echo Running tests...
sfdx force:apex:test:run -u prod-org

echo Deployment to production environment completed successfully!
pause
