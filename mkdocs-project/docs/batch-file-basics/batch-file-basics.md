# Windows Shell / Batch File Basics #

This documentation provides an overview of important batch file concepts.
This documentation is not an exhaustive reference for batch files but provides
important background and examples that are key to writing batch files.

The following are useful resources found on the internet.
Use the table of contents and index features of each site to find information about a specific
batch file language feature, or search the internet.  

* [Windows commands](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands) - Microsoft reference
* [Windows Batch Scripting WikiBook](https://en.wikibooks.org/wiki/Windows_Batch_Scripting) - comprehensive reference
* [Batch Script Tutorial from Tutorials Point](http://www.tutorialspoint.com/batch_script/)

The following are important topics to get started:

* [Batch File Name and Location](#batch-file-name-and-location)
* [Case Insensitivity](#case-insensitivity)
* [Running Batch Files](#running-batch-files)
* [First Line](#first-line)
* [Batch File Main Entry Point](#batch-file-main-entry-point)
* [Comments](#comments)
* [Variables](#variables)
* [Labels](#labels)
* [Built-in Commands and External Programs](#built-in-commands-and-external-programs)

In addition to the above basic topics,
the following topics are listed roughly in order of complexity
and highlight some of the most useful features of batch file syntax.

* [`exit` Statement](#exit-statement) - exit the batch file (or function)
* [`if` Statement](#if-statement) - if conditional block
* [`for` Statement](#for-statement) - for loops
* [Functions](#functions)

--------------------

## Batch File Name and Location ##

Batch file names traditionally have the extension `.bat` (although `.cmd` can also be used),
which indicates to Windows (by file extension association) that the batch file can be run with the `cmd` shell.
Other file extensions such as `.exe` are also interpreted as executable programs.

The convention of relying on file extensions to identify executable programs is different than Linux,
where files must be have execute permissions set in order for the file to be executable
(or run with, for example `sh scriptname`).
Linux shell scripts do not need to have an extension such as `.sh` or `.bash` and there
are differing opinions on whether using extensions for executable programs is a best practice.
However, in a mixed environment such as Cygwin, Git Bash, MinGW, or other system where Linux is run
on host Windows operating system, it can be helpful to always use file extensions for Linux scripts to avoid confusion.
The Git version control system can store an "executable bit" for a file, indicating that it is executable,
but this does not apply to batch files since Windows looks at the file extension.

The default for ***File Explorer*** is to not show file extensions.
However, selecting the ***File Explorer*** ***View / File name extensions*** checkbox shows file extensions,
which makes it easier to see batch files on the file system.

Batch files can be created in any folder.
although it may make sense to use conventions such as placing batch files in a `bin` folder,
which is traditionally used for executable programs, many of which contain binary content rather than text.
If a batch file is globally useful, then saving in a folder in the `PATH` may make sense (see the next section).

## Case Insensitivity ##

The Windows operating system and `cmd` program is generally case-insensitive when
specifying program names, commands, and file paths.
Consequently, to list directories, use `DIR` or `dir`.
This is in contrast to Linux, which is generally case-sensitive.

Specific programs, in particular external software installed on the computer,
may be case sensitive or case insensitive,
for example for command parameters.  Refer to documentation for each program.

## Running Batch Files ##

Batch files can be run from the `cmd` prompt, by clicking on the file in ***File Explorer***,
or by calling from another batch file or program.

If calling a batch file from an executable program,
for example a Java, Python, or C# program,
it is generally required to call the `cmd` program with batch file name as an argument.
Most languages provide library functions to call shell programs.

If the folder including a batch file is included in the `PATH` environment variable,
then typing the batch file name at the `cmd` prompt with our without the `.bat` extension will cause the batch file to run.
The batch file can also be run by entering the full or relative path to the batch file.
Unlike Linux, Windows will run a batch file in the current folder even if the current folder (`.`) is not in the `PATH`.
On Linux, if `.` is not in the path, then a Linux shell script can be run with `./scriptname`.

There are some considerations for how the batch file is run because of how the `cmd`
treats the scope and exit of the called batch file.
For example, if one batch file calls another batch file,
the [`call`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call) command should be used, similar to the following:

```
@echo off
rem Main batch file

call batchfile2.bat
```

If `call` is not used before the second batch file name,
then the main batch file will exit when the child batch file exits.
This is confusing if additional code should run after the batch file is called.

## First Line ##

Unlike Linux shell scripts that use `#!program` to indicate the program to run for the shell script,
the first line of a batch file does not have any significance to the
command shell or operating system.

By default, when the batch file is run, each line is echoed to standard output.
This tends to be overwhelming and therefore the following first line is typically used to
turn off echoing output:

```
@echo off
```

## Batch File Main Entry Point ##

A batch file is entered at the first line.
Each command is processed in order unless control commands such as `goto` or other
code blocks influence the program flow.
The following example illustrates typical code organization.
Using `rem` at the beginning of a line (can be indented) indicates that the line is a comment.

```sh
@echo off
rem ProgramName - short description

set version=1.0.0

rem Determine the folder that the script exists in
rem - used so that all files can be relative to the location
set scriptFolder=%~dp0
rem Remove trailing \ from scriptFolder
set scriptFolder=%scriptFolder:~0,-1%
set scriptName=%~nx0

rem Parse command line using simple approach
if "%1%"=="/h" goto printUsage
if "%2%"=="/h" goto printUsage

rem Insert logic here.

rem Call a function, just have `call` at the front.
call :function1 args...

rem Example function
:function1
rem Some logic here
rem return from the function
exit /b 0

rem Print program usage
:printUsage
echo.
echo Usage here...
goto exit0

rem Final exit
:exit0
exit /b 0
```

## Comments ##

Comments in batch files use the `rem` statement.

* See the [`rem`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/rem) statement documentation

The following examples illustrates the use of comments.

```
@echo off
rem First comment.
rem Second comment.
   rem OK to indent comments, for example when in an 'if' or 'for' block.
```

* It is OK to indent comments, for example when in an 'if' or 'for' block.
* Some programmers use double-colon (`::`) or other invalid labels to start comments.
Although this works and may be more readable to some programmers,
the use of `rem` is recommended way to insert comments.

## Variables ##

Variables in batch files are defined using syntax similar to the following.
It is possible to use data types such as strings, integers, and floating point numbers;
however, strings are the simplest to deal with, for example:

```
set a=hello world
```

* There should be no spaces on either side of the equal sign.
* For strings, do not surround with double quotes because they will be treated literally as part of the string.
Other syntax may allow using surrounding double quotes,
for example when processing filenames that contain spaces.

The value of a variable can be referenced by surrounding variable name with `%`, as in the following syntax.
Unlike Linux, which uses `$` at the start of the variable name, or `${name}`, the `%` are required on both
sides of the variable.

```
set s1=string1
set s2=%s1%
```

If variable values are not as expected, in particular when using `for` loops and complex logic,
then use syntax similar to the following, which uses exclamation point instead of `%`.
By default, variable values are set when lines are parsed, which is a holdover of behavior
from early versions of the software.
However, this behavior does not work properly when `for` loops and other complex logic are used.
Consequently the `setlocal` syntax was added later.

```
setlocal EnableDelayedExpansion

set s1=string1
set s2=!s1!
```

* See Microsoft [setlocal](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/setlocal) documentation
* See [SETLOCAL](https://ss64.com/nt/setlocal.html) documentation on ss64.com
* See [EnableDelayedExpansion](https://ss64.com/nt/delayedexpansion.html) documentation on ss64.com

## Labels ##

The logic control features of batch files are not as easy to use as those of Linux scripts,
although with experience it is possible to write batch files that are modular and highly functional.

A simple control method is to use `goto` statements with labels.

* See the [`goto`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto) command documentation
* See the [`label`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/label) statement documentation

For example:

```
if "%x%"=="true" goto someLabel

:someLabel
rem This code does something...
```

* Multiple labels are typically inserted in code at important logic points.
* In order to prevent logic from one label code block from bleeding into the next code block,
additional `goto` statements are needed to jump through logic.
* It is useful to include standard labels such as `:exit0` to exit with code `0` and `:exit1` to exit with code `1`.
* Labels are also used to define [functions](#functions).

## Built-in Commands and External Programs ##

The terms "commmand" and "program" may be used interchangeably and cause confusion.
The `cmd` program, which is actually an executable program named `cmd.exe`, behaves as follows:

* includes built-in commands (e.g., [`dir`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir))
* language syntax elements, or "statements" (e.g., [`if`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/if))
* can call external programs by searching the `PATH`, current folder, and specified paths to programs

For example, the `if` statement is so fundamental to the `cmd` shell's functionality that it is compiled into the program.
The `dir` command is a foundational command and is also compiled into the shell.
This can be verified by running:

```
> which dir
'which' is not recognized as an internal or external command,
operable program or batch file
```

In contrast, the `taskmgr` program is an external program and when run from command prompt displays the ***Task Manager***.

```
> which taskmgr
C:\Windows\System32\Taskmgr.exe
```

Built-in commands and statements are compiled into the `cmd` program, whereas external programs are located using the `PATH` environment variable.

# `exit` Statement ##

The `exit` statement exits a batch file or function, optionally with an integer return code.

* See the [`exit`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/exit_2) statement documentation

It is typically to use a `0` (zero) exit code to indicate success, and `1` or other non-zero value to indicate an error.
Some programs use specific error code values to communicate the error type with calling code.
It is also useful to put one ore more variants of `exit` label at the end of the batch file, which can be jumped to from logic
(**do not** use a label named `:exit` because this seems to confuse the `cmd` shell).
The following is an example of using `exit`:

```
@echo off
rem example of exit

rem Some logic here

if  ... condition that causes program to exit ... (
  rem Go to the end of the batch file with exit code of 0
  goto exit0
)

rem More logic here 

:exit0
rem Exit the batch file with success code
exit /b 0
```

* The above `exit0` cannot be called as a function using `call :exit0` because the `exit` would only return from the
function, not exit the batch file.
* The `/b` parameter should typically be used to indicate that the `cmd` shell that is running the batch file
should not itself exit.

## `if` Statement ##

The `if` statement performs conditional processing in batch files so that logic decisions can be made.  See:

* [`if`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/if) documentation

A typical example is to compare the value of a string to a variable and jump to another point in the batch file.
In the following example, `string1` and `string2` are literal strings.  They do not need to be surrounded by double quotes.

```
s1=string1 with spaces
s2=string2

if "%s1%"=="%s2%" goto someLabel

:someLabel
rem do some more work...
```

* Spaces are not allowed on either side of the condition `==` operator.
* If the variable value may be an empty string, use double quotes to surround the variable to
ensure that an empty string will not cause a syntax error; if a literal string is compared
also surround it with double quotes.  The double quotes are essentially treated as literal in the `if` comparison
so include on both sides of the comparison.

A single line `if` command such as the above allows only simple logic.
The following example shows an `if` statement that uses parentheses to create a multi-line logic block.
This example uses the `exists` condition to check for file existence.

```
fileName=C:\path\to\file
if not exists "%fileName%" (
  echo File does not exist:  %fileName%
  goto exit1
)
```

* There **must** be a space before the `(` and no space will cause an error
* commands within the block can be indented

It is also possible to perform more complex logic using `if` and `else` statements.
However, care must be taken to format the code to prevent syntax errors.
The following is an example of valid code:

```
if "%x%"=="1" (
  rem Do logic block 1
) else (
    if "%x%"=="2" ( 
      rem Do logic block 2
    )
  ) else (
       rem Fall through case
    )
```

* the syntax `else if` **cannot** be used; instead split into two lines with `) else (` on the first line
and `if ... (` on the following line
* because no `else if` (or `elseif` or `elif`) syntax is supported,
complex nested conditions require more nested levels
* the `) else (` with parentheses must occur on the same line, with spaces as shown
* multiple conditions can be used
* the command shell will treat multi-line `if` blocks as one command; therefore,
echo statements may show multiple lines and error messages may appear to
originate anywhere in the block, rather than on a specific line

## `for` Statement ##

The `for` statement provides functionality to loop over a list.

* See the [`for`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/for) statement documentation

Because of limitations in command shell statements, the `for` statement is also often used
to creatively to solve problems, even when it would not be used similarly in other languages.

See the [Useful Batch File Examples](../useful-batch-files/useful-batch-files.md) for specific examples of the `for` loop.

Using `for` loops often requires using `SETLOCAL EnableDelayedExpansion`,
as discussed in the [`Variables`](#variables) section, to ensure that variable values are properly set.

The following example searches for whether QGIS software is installed in a particular folder on the system
(typically like: `C:\Program Files\QGIS 3.10`),
so that the version can be detected, with preference for the latest version.

```
for %%G in (3.12 3.10 3.4) do (
  rem Set a local variable to make code easier to understand
  set qgisVersion=%%G
  if exists "%%G:\Program Files\QGIS !qgisVersion! (
    set targetQgisVersion=!qgisVersion!
    echo Found QGIS software installation for version !targetQgisVersion!.
    goto runStandaloneQgis
  )
)
```

* The special varable syntax `%%G` is used to iterate over variable `G`.
* The values to iterate over are listed in parentheses.
* Experience has shown that it is better to keep the `in` list simple and expand strings with spaces, etc. in
the block of code following the `for` line.
* Spaces in the wrong places can cause issues.  Use syntax similar to that shown in the above example.

## Functions ##

Functions are implemented in batch files by relying on
[`call`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call) command,
[`label`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/label), and
[`exit`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/exit_2) command.
Batch file functions are similar in concept to functions in Linux shell scripts and other languages;
however, the syntax is different.

The following example `example-function.bat` illustrates how a function can be defined in a batch file.

```
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
```

The output from running the above batch file is:

```
Log file for program example-function.bat
INFO: "Some message"
WARNING: "Another message"
```

* The function is declared with a `label`.
* The function is called using `call :label` syntax.
	+ Parameters to the function are passed after the `call :label` syntax.
* Parameters within the function are interpreted as if the function was called as a separate batch file.
* The function returns an integer exit code using an `exit` command.  In this case the exit **does not** exit the batch file.
