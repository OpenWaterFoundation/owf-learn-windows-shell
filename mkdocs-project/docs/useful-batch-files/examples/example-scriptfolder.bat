@echo off
rem Echo illustrating how to get batch file folder and its parent folder.

rem Determine the folder that this batch file exists in:
rem - used to provide path relative to the batch file location
set scriptFolder=%~dp0
rem Remove trailing \ from scriptFolder
set scriptFolder=%scriptFolder:~0,-1%
rem Also get the script name without leading path.
set scriptName=%~nx0

rem Get the parent folder, which is the folder for the full software install.
rem Have to get parent folder using Windows for loop approach
for %%i in (%scriptFolder%) do set installFolder=%%~dpi
rem Remove trailing \ from installFolder
set installFolder=%installFolder:~0,-1%

echo scriptFolder=%scriptFolder%
echo installFolder=%installFolder%

exit /b 0
