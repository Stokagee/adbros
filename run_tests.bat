@echo off
REM Robot Framework Demo Test Runner for AdBros
REM This script runs the complete test suite in Docker
REM Use --build flag to force rebuild: run_tests.bat --build

setlocal EnableDelayedExpansion

REM Parse arguments
set BUILD_FLAG=
if "%1"=="--build" set BUILD_FLAG=--build

REM Initial run
goto :run_tests

:run_tests
echo ========================================
echo   Robot Framework Demo for AdBros
echo ========================================
echo.

if "%BUILD_FLAG%"=="--build" (
    echo Building Docker image and running tests...
) else (
    echo Running tests with existing Docker image...
)
echo.

docker compose up %BUILD_FLAG%

echo.
echo ========================================
echo   TEST EXECUTION COMPLETED
echo ========================================
echo.
echo [+] RESULTS & LOGS [+]
echo   [*] Summary:  reports\report.html
echo   [*] Detailed: reports\log.html
echo   [*] Raw data:  reports\output.xml
echo.
echo [+] NEXT STEPS [+]
echo   [*] Run again:       run_tests.bat
echo   [*] Force rebuild:   run_tests.bat --build
echo   [*] Clean containers: docker compose down -v
echo.
echo [+] RUN STATISTICS [+]
echo   Check reports\report.html for:
echo     - Total tests passed/failed
echo     - Execution time
echo     - Critical errors
echo.
echo ========================================
echo.

REM Clear BUILD_FLAG for subsequent runs
set BUILD_FLAG=

:menu
echo What would you like to do?
echo   [G] Open report in browser
echo   [A] Run tests again
echo   [L] Leave (quit)
echo.
set /p choice="Your choice: "

if /i "!choice!"=="g" (
    echo.
    echo Opening report...
    start reports\report.html
    echo Report opened!
    echo.
    goto menu
)
if /i "!choice!"=="a" (
    echo.
    goto run_tests
)
if /i "!choice!"=="l" (
    goto :eof
)

echo Invalid choice. Please try again.
echo.
goto menu
