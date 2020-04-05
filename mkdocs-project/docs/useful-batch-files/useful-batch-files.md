# Windows Shell / Useful Batch File Examples #

This page provides examples of useful batch files and nuggets of code that can be used in batch files.

* [Determine the folder where a batch file exists](#determine-the-folder-where-a-batch-file-exists)
* [Parsing command line options](#parsing-command-line-options)
* [Run a Cygwin Program from a Batch File](#run-a-cygwin-program-from-a-batch-file)
* [Set Command Prompt Window Title](#set-command-prompt-window-title)

-----------------

## Determine the folder where a batch file exists ##

Batch files often need to know the location of input and output files.
This can be complicated by how the batch file is run, for example by specifying
the name in the current folder, using an absolute or relative path to a different folder,
or being found in the `PATH` environment variable.

One option is to require that a batch file is executed from a specific folder,
such as the location of the batch file.  However, this reduces flexibility.
To allow running the batch file from any folder,
it is necessary to determine the absolute location of the script so that input and output
can be specified relative to that location.
The following example determines the absolute path to the batch file being run:

```
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
rem Have to get parent folder using Windows for loop approach.
for %%i in (%scriptFolder%) do set installFolder=%%~dpi
rem Remove trailing \ from installFolder
set installFolder=%installFolder:~0,-1%

echo scriptFolder=%scriptFolder%
echo installFolder=%installFolder%

exit /b 0
```

* Substrings are processed using `:~` operators.
See [String processing](https://en.wikibooks.org/wiki/Windows_Batch_Scripting#String_processing) documentation.
* File and folder names are processed using `%~` operators.
See [Percent tilde](https://en.wikibooks.org/wiki/Windows_Batch_Scripting#Percent_tilde) documentation.
* The `for` statement is used to determine the parent folder for the script folder
because there is no equivalent to Linux `dirname` command.
Note that the `for` loop index variable `i` in `%%i` must match the character at the end of the line (`~dpi`).
* Be careful reusing variables in `for` loops and make sure delayed expansion is not an issue throughout the batch file.
If variable values are not as expected, `setlocal EnableDelayedExpansion` may be necessary.
See the [`setlocal`](https://ss64.com/nt/setlocal.html) documentation.

## Parsing command line options ##

A common task when writing a batch file is to parse command line parameters.
Parameters may take various forms including:

* `-a` or `/a` - single character option
* `-a xyz` - single character option with an argument
* `-abc` - long option with single dash
* `-abc xyz` - long option with single dash with an argument
* `--aabc` - long option with multiple dashes
* `--aabc xyz` - long option with multiple dashes with an argument
* `--aabc=xyz` - long option with multiple dashes and assignment using equal sign 

Windows programs have traditionally used the forward slash (`/`) to indicate command parameters.
However, this conflicts with Linux-like paths (`/folder1/folder2/file`).
Linux-style dash syntax is often used rather than forward slashes,
especially if software is designed for Linux.

It is possible to use a `for` statement to loop through command parameters and an example will
be added here in the future.
However, for simple programs that expect only one or two command parameters to be specified,
using a brute force approach works.  For example:

```
@echo off
rem Example showing brute force command line parsing.

if "%1%"=="/h" goto printUsage
if "%2%"=="/h" goto printUsage
if "%1%"=="-h" goto printUsage
if "%2%"=="-h" goto printUsage
if "%1%"=="/?" goto printUsage
if "%2%"=="/?" goto printUsage

:printUsage
rem
echo Print the usage here
goto exit0

:exit0
rem Exit the batch file with code 0
exit /b 0
```

* The above batch file expects zero to two parameters.
Therefore command parameter `%1%` and `%2%` are checked.
* A `:printUsage` label and
[`goto`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto)
command are used to jump to the desired code.

## Run a Cygwin Program from a Batch File ##

It may be difficult to implement required functionality in a Windows batch file.
A Cygwin shell script may be able to perform a task more easily.
The following example illustrates how to call a Cygwin script from a batch file.

```
set gpTempFile=%TMP%\sometempfile.tmp
C:\cygwin64\bin\bash --login -c "echo HOME=$HOME"
C:\cygwin64\bin\bash --login -c "echo USER=$USER"
C:\cygwin64\bin\bash --login -c "echo $(pwd)"
rem Redirect Cygwin program output to a temporary file
C:\cygwin64\bin\bash --login -c "path/to/program" > %gpTempFile%
rem Read the temporary file into 'gpVersion'
set /p gpVersion=<%gpTempFile%
```

* The default Cygwin install location is assumed (using the default location is advised to prevent issues)
* It is important to know the location where the Cygwin shell opens as well as the value of important
environment variables, which will impact the behavior of the called Cygwin program.
The echo statements above help to understand the environment.
* In order to find the program on Cygwin, it must be in the path, be specified as an absolute path,
or be specified relative to the program startup location.
* Windows does not provide a way to assign output of a program to a variable.
Using a temporary file is one way to overcome this limitation.

## Set Command Prompt Window Title ##

It can be helpful to set the title of a command prompt window,
for example to indicate that the command prompt tool is configured for an environment.
For example, a script may be run to configure the `PATH` and other environment variables
necessary to run software within the command prompt window.
The [`title`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/title_1)
command is used to set the title, for example:

```
@echo off
rem Example of how to set command prompt window title

rem Configure the environment for software tool
set ENV_VAR1=some value
set ENV_VAR2=some value

rem Set the title to indicate that the command prompt window is configured for ABC software.
title Command shell window for ABC software

exit /b 0
```

* The text following `title` should not be surrounded by double quotes
* The title can be changed multiple times by repeatedly using the `title` command
