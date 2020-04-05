# Windows Shell / Troubleshooting #

Troubleshooting batch files typically involves reviewing error messages printed by the shell program.
However, the Windows shell is quite bad at providing useful information.
Often, error messages are too general and the exact location of the error may not be indicated.
If a useful message is printed, the fix requires interpreting how to respond to a printed error message.
Troubleshooting tricks include the following, which are explained in sections below:

* [Redirect the output from the program to a file](#redirect-the-output-from-the-program-to-a-file)
* [Use `@echo on` to echo all lines](#use-echo-on-to-echo-all-lines)
* [Add `echo` commands to print information](#add-echo-commands-to-print-information)

Common errors are listed below and are explained in sections below:

* Need to add

----------------------

## Redirect the output from the program to a file ##

The easiest way to output information from a shell script is to use the `echo` command.
For example, the following prints one message to standard output and one message to standard error:

```sh
rem Print message to standard output
echo standard output message

rem Print message to standard error
echo standard error message 1>&2
```

Both messages will be visible in the command shell window.
The output can then be scrolled through to review results of the script.
However, this can be cumbersome, especially if the output is long and it is necessary to search for a string.
One way to resolve this is to redirect the output to a file so that the file can then be edited in a text editor.

Programs in most operating systems can generate output to different *streams* and these streams
can be redirected to files (see [Redirection on Wikipedia](https://en.wikipedia.org/wiki/Redirection_(computing))).
The standard output and standard error streams are used for printing messages.
The following syntax can be used to redirect a program's standard output stream to a file.

```sh
example-redirection.bat > example-redirection.stdout
```

The following example redirects only the standard error messages to a file,
where the number `2` indicates the standard error stream:

```sh
example-redirection.bat 2> example-redirection.stderr
```

It is often useful to redirect the standard output and standard error streams to the same output file,
as follows:

```sh
example-redirection.bat > example-redirection.allout 2>&1
```

Because the standard output and standard error messages are handled separately within the
program, they may not actually be printed in the expected sequence,
and it may not be obvious whether a message is an error message.
For this reason, it is often helpful to include `ERROR` or other indicator in the message
to differentiate from an informational message.

## Use `@echo on` to echo all lines ##

The default for batch files is to echo each line as it is run,
which can lead to excessive and distracting output,
especially when the messages are mixed with valid program output.
Consequently, many batch files start with the following line:

```
@echo off
```

To enable echoing each line, comment out the above line as follows:

```
rem @echo off
```

or change to:

```
@echo on
```

If an error occurs, the last line that is printed should be near the error.
However, in some cases the syntax problem may be so severe that this is misleading.
For example, `for` and `if` blocks that use parentheses may be treated as one command by the shell
even though the logic spans multiple lines.

## Add `echo` commands to print information ##

Simple `echo` commands in a script can be used to print troubleshooting information.
These can be added as needed or can be formalized into debugging messages as in the example below.
The debug variable can default to `false` and can be set with a command line parameter.
In any case, troubleshooting messages inserted for ad hoc debugging should not
be printed for users in most cases because extraneous output can be overwhelming and confusing.

```sh
@echo off

rem Example of using debug messaging

set debug=true

rem Simple function
if "%debug%"=="true" (
  echo DEBUG:  some message here
)
```

Note that messages should not be surrounded by quotes as they will be printed.
