# Windows Shell / Batch File Best Practices #

This page lists best practices, based on industry standards and first-hand experience.

* [Use simple batch files to memorialize tasks](#use-simple-batch-files-to-memorialize-tasks)
* [Use version control](#use-version-control)
* [Write code that is understandable](#write-code-that-is-understandable)
* [Check whether the batch file is running in the correct folder](#check-whether-the-batch-file-is-running-in-the-correct-folder)
* [Echo useful troubleshooting information](#echo-useful-troubleshooting-information)
* [Consider options for logging](#consider-options-for-logging)
* [Create documentation](#create-documentation)
* [Include useful web resource links in batch file comments](#include-useful-web-resource-links-in-batch-file-comments)
* [Learn how to use shell features](#learn-how-to-use-shell-features)
* [Use functions to create reusable blocks of code](#use-functions-to-create-reusable-blocks-of-code)

-----------------

## Use simple batch files to memorialize tasks ##

It is often necessary to perform a number of steps to process data and/or automate program calls to complete a task.
These steps may be a one-time task, but often will need to be repeated in the future.
Rather than relying on written or electronic notes, email, etc., creating a short batch file to memorialize
the task can ensure that knowledge is retained.
The batch file can also be enhanced over time to provide more functionality.

A useful best practice is to create a simple batch file with data files files that are processed,
with comments in the batch file to explain its purpose and use.
Additionally, a `README.md` file can be created to provide formatted explanation of the batch file.

The batch file and `README.md` file can be managed in a version control system to track changes over time and serve as a backup.

## Use version control ##

Any batch file worth creating and using is probably worth tracking in a version control system.
There is nothing more frustrating that asking "where did I put that batch file?"
Therefore, use Git and a cloud-hosted version control system like GitHub or Bitbucket to maintain the batch file.
This also provides information about the author so that questions and bugs can be dealt with,
for example via the repository issues page.

If a true version control system is not used, the batch file can also be saved in a knowledge base or other
information platform.

## Write code that is understandable ##

It is common that code is rewritten simply because the original author's work is not understandable.
This results in extra cost, potentially bugs, and potentially loss in functionality if the original
code was not understood.
The urge to rewrite code may be because of a lack of documentation, confusing logic, bad programming style,
use of obscure or advanced language syntax without explanation, or other reasons.

Documenting code at the time it is being written is the best time to document code.
If updating code, read the code comments again and if they do not make sense, clarify the comments.
A simple rule is to ask "will the next person working on this code understand it?"

The following are some basic guidelines to making code understandable:

* Add full grammar comments to code.  Don't force people to assume what is meant.
Use proper grammar.  Sloppy comments and incomplete thoughts can indicate sloppy code.
* Explain complex syntax.  Don't assume that the next programmer will have a PhD in batch file programming.
Yes, every answer can be found on the web, but the web also contains many misleading and out of date examples.
Time is valuable and forcing others to re-research code costs money.
* Use variable and function names that are verbose enough to provide context.
Code should read like a clear process.  Using appropriate names will also reduce
the need for code comments.
* Be consistent in names and style.  If editing someone else's code, try to be consistent
with the original style if possible.
* Use appropriate indentation consistently.  Tabs are OK and if used should not be mixed with spaces.
Spaces if used should be in groups of 2 or 4.  Do not assume that the next person to edit
the code will use the same convention in their editor, and make it obvious what is being used
by being consistent.

## Check whether the batch file is running in the correct folder ##

The folder from which a batch file is run often has a large impact on the functionality of the batch file.
Options include:

1. Allow the batch file to run in any folder since the task does not depend on the location.
2. Allow the batch file to run in any folder and locate input and output based on the
environment, such as detecting the user's home folder or a standard folder structure within the environment.
3. Require the batch file to be run from a certain folder because input and output folders are relative
to the run folder.

Great pains may need to be taken in a batch file's code to ensure that a batch file runs correctly in any folder,
in order to ensure that input files are found and output is created in the proper location.
However, for simple tasks, it may be easier to require running from a specific folder.

A best practice is to put checks in place, if necessary, to ensure that the batch file is running in the
correct folder. For example, the following does a simple check to make sure that
the batch file is running in a `build-util` folder.
The following check is not fool-proof because running in one `build-util` folder and specifying
a path to another `build-util` folder would pass the test, but the basic check helps prevent many issues.

```sh
rem Make sure that this is being run from the build-util folder
if "%dirname%"=="build-util" (
  echo Must run from build-util folder
  exit /b 1
)
```

A more robust solution is to allow the batch file to be run from any folder,
including cases where the batch file is found in the `PATH`, the current folder,
or the path to the batch file is fully specified.
In this case the following syntax can be used to determine the location of the batch file,
and other folders and files can be located relative to that location,
assuming there is a standard.

```sh
rem Determine the folder for the batch file
set scriptFolder=%~dp0
rem Remove trailing \ from scriptFolder
set scriptFolder=%scriptFolder:~0,-1%
rem Script name without leading path
set scriptName=%~nx0
```

## Echo useful troubleshooting information ##

Batch files can be difficult to troubleshoot, especially if the batch file coding is not clear
and the user did not write the batch file.
Therefore, it is often helpful to print important configuration information
at the start of the batch file.
For example use `echo` statements to print important environment variable names and values,
names of input files, etc.

If the batch file is more advanced, such output could be printed only when a command line parameter is specified, such as `--verbose`.

## Consider options for logging ##

Logging for batch files can be implemented in various ways.
A typical standard is to output to the `stdout` stream (for example `echo ...`) or `stderr` stream.
The batch file output can then be redirected into a file or piped to another program for further processing.
However, diagnostic or progress messages that are separate from analytical output generally
need to be separated from the general output.

Depending on the complexity of the batch file, it may be very useful to save logging messages to a file.
This can be done by echoing output to a file in the current folder or a special location.
The author of the batch file probably has a good idea of how logging should be done because
they use it themselves.
A best practice is to implement options for logging in a way that will benefit users of the batch file
and then provide documentation to explain options.
This will help users, especially those who may not fully understand how to do logging with
redirection.

The following is a basic example of implementing logging:

```sh
@echo off

rem example-logging

rem This example shows basic logging approach

rem Define the logfile
rem - in this case it is a temporary file but a name and location
rem   specific to the batch file purpose would normally be used
set logFile=program.log
set scriptName=%~nx0

rem Write one record to the logfile indicating the time and program
rem - use tee command to show output to terminal and logfile if appropriate
rem - write standard output and error to the file
echo Logfile for %scriptName%:  $logFile > "%logfile%"

# Write subsequent message by appending
echo Another log message >> "%logfile%"
```

## Create documentation ##

A batch file is only truly useful if someone other than the original author can use it.
Therefore, all batch files should have documentation in one or more forms,
depending on the significance of the batch script, including:

* Code comments, enough to understand the purpose, and good in-line comments.
* A `printUsage` or similar function that prints basic usage,
run via `-h` or `--help`, or by default to show user available command options.
* `README.md` file in the repository.
* User documentation, such as this documentation.

## Include useful web resource links in batch file comments ##

Technologies can be complicated and shell programming is no different.
It is often necessary to search the web for a solution or comparative example to perform a task.
Once the solution is coded, it can be difficult to understand the approach.
Therefore, include a comment in the code with the link to the web resource that explained the solution.
Don't make the next programmer relearn the same material from terse code.
Allow the code to be a teaching tool that can be maintained by the next developer.
Also, including links is a way to give credit to the person that helped solve a technical issue.

## Learn how to use shell features ##

There is always a brute force "quick and dirty" way to do things,
such as by copying and pasting code from a web search.
However, there is a balance between the technical debt of quick and dirty solutions,
and more elegant solutions that take more time to learn, but are more robust and maintainable in the long run.
Also, using examples without understanding can have unintended consequences that result in new bugs.
In particular, quick and dirty solutions that negatively impact the user experience
and resources spent by other developers should be avoided.
Shell programmers should take the time to learn shell programming concepts and features such
as command line parsing, functions, log files, etc. so that they can improve batch file quality
and functionality.
This documentation is an attempt to provide easily understood examples that go beyond
the often terse and trivial examples on the web.
 
## Use functions to create reusable blocks of code ##

This should go without saying, but modular code tends to be easier to maintain,
especially when a batch file becomes long.
Every batch file author should consider using functions to organize batch file functionality.
Functions also simplify sharing code between batch files since functions can be copied and pasted
between batch files.

The alternative to writing a function is to write a separate batch file that can be called
with an appropriate command line.
This approach is OK as long as the called batch file is located in a location that can be found by the calling batch file.
It may be easier to main code with copy/paste sections rather than dealing with
maintaining family of related batch files, depending on how well-integrated the software is.

See the [Functions](../batch-file-basics/batch-file-basics.md#functions) documentation for information about using functions.

Batch files can suffer from using [`goto`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/goto)
rather than taking the time to write functions.
Because `goto` statements are so often used with batch files and can be effective,
judgement should be used to decide how much effort should be invested to convert batch file code to use functions.
