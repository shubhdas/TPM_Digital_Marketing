@echo off
echo Deploying to Staging Org...
sf deploy metadata --source-dir force-app/main/default --target-org digital-marketing-staging
if %ERRORLEVEL% EQU 0 (
    echo Deployment to Staging Org completed successfully!
) else (
    echo Deployment to Staging Org failed!
    exit /b 1
)
pause
