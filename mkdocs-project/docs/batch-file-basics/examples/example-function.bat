@echo off

rem Example of using a function

rem Program name
set scriptName=%~nx0

rem Log file
set logFile=%scriptName%.log
echo Log file for program %scriptName%>%logFile%

rem Call the function
call :logInfo Some message
call :logWarning "Another message"

goto exit0

:logInfo
rem Function to print an information message to the log file
rem - requires that global variable logFile is set to the file
rem - output is always appended so restart the file elsewhere
rem - called arguments can be surrounded "with quotes", or not
rem - output messages are always surrounded by quotes
rem echo the message
echo INFO: %* >> "%logFIle%"
rem Return a status, must be integer, not needed but could be used to indicate success.
exit /b 0

:logWarning
rem Function to print a warning message to the log file
rem - requires that global variable logFile is set to the file
rem - output is always appended so restart the file elsewhere
rem echo the message
echo WARNING: %* >> "%logFIle%"
rem Return a status, must be integer, not needed but could be used to indicate success.
exit /b 0

:exit0
rem Final exit
exit /b 0
