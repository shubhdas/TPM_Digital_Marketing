@echo off
echo Running all tests...
sf run test --target-org digital-marketing-dev --wait 10
if %ERRORLEVEL% EQU 0 (
    echo All tests completed successfully!
) else (
    echo Some tests failed!
    exit /b 1
)
pause
