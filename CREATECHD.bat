@echo off
setlocal

REM Function to create CHD files for all files in the given directory
:CREATE_CHD_FILES
setlocal enabledelayedexpansion
set "path=%~1"
for %%F in ("%path%\*") do (
    if exist "%%F" (
        chdman createdvd -i "%%F" -o "!path!\%%~nF.chd"
    )
)
endlocal
exit /b

REM Check if path argument is provided
if "%~1"=="" (
    echo Usage: %0 ^<path^>
    exit /b 1
)

REM Check if the provided path exists
if not exist "%~1" (
    echo Error: The specified path does not exist.
    exit /b 1
)

REM Create CHD files for all files in the provided directory
call :CREATE_CHD_FILES "%~1"
