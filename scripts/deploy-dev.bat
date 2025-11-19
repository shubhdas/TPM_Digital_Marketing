@echo off
echo Deploying to Development Org...
sf deploy metadata --source-dir force-app/main/default --target-org digital-marketing-dev
if %ERRORLEVEL% EQU 0 (
    echo Deployment to Development Org completed successfully!
) else (
    echo Deployment to Development Org failed!
    exit /b 1
)
pause
