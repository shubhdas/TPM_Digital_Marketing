@echo off
REM Script to run all tests

echo Running all tests...

REM Check if Salesforce CLI is installed
where sfdx >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Salesforce CLI is not installed. Please install it first.
    pause
    exit /b 1
)

REM Run all tests
echo Running all tests...
sfdx force:apex:test:run -u dev-org

echo Tests completed!
pause
