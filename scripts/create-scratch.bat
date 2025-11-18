@echo off
REM Script to create a new scratch org

echo Creating new scratch org...

REM Check if Salesforce CLI is installed
where sfdx >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Salesforce CLI is not installed. Please install it first.
    pause
    exit /b 1
)

REM Create scratch org
echo Creating scratch org from dev definition...
sfdx force:org:create -f config/dev-scratch-def.json -a dev-org -d 30

REM Assign permission set
echo Assigning permission set...
sfdx force:user:permset:assign -n DigitalMarketingDeveloper

REM Open org
echo Opening org...
sfdx force:org:open -u dev-org

echo Scratch org created successfully!
pause
