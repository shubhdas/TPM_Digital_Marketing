@echo off
echo Deploying to Production Org...
sf deploy metadata --source-dir force-app/main/default --target-org digital-marketing-prod
if %ERRORLEVEL% EQU 0 (
    echo Deployment to Production Org completed successfully!
) else (
    echo Deployment to Production Org failed!
    exit /b 1
)
pause
