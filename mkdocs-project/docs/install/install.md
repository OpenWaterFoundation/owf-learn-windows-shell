# Windows Shell / Select and Install Shell Software #

Selecting a Windows shell will define the features of the shell programming language.
Windows shell software must be installed before running the shell command program and shell scripts.

The Windows `cmd` program that runs `.bat` batch files is installed by default on Windows computers and does not require additional actions.
However, alternatives are available and are listed below.

* [Choosing a Windows Shell](#choosing-a-windows-shell)
* [Installing Cygwin](#installing-cygwin)
* [Installing MinGW](#installing-mingw)
* [Installing Git for Windows (Git Bash)](#installing-git-for-windows-git-bash)
* [Installing the Linux Subsystem on Windows 10](#installing-the-linux-subsystem-on-windows-10)

-------

## Choosing a Windows Shell ##

The `cmd` program shell is installed on Windows by default and is the focus of this documentation.
There should typically be no reason to change the default installation.

PowerShell is also available on Windows computers but is not discussed because it
is typically used for system administration tasks and on Windows servers.

In many cases, the default `cmd` shell program that is installed will be sufficient,
but it is sometimes useful to install other shell programs, for example:

* the computer is used by a software developer that needs to automate
tasks and Windows batch files are insufficient or difficult to work with
* the computer runs software in a Linux shell and therefore interacting
with such software requires or is easier with a Linux shell
* Windows batch files cannot handle or are difficult to implement for a task

Linux shell programmers can usually identify whether a Windows command
is available to do a task by searching the internet.
In some cases there are equivalent Windows and Linux shell features and commands,
but in many cases Windows is lacking, without installing a Linux shell.

Installing a Linux-like shell program on Windows involves selecting one or more
Linux variants that can be supported by the person and within the organization,
for the tasks that will use the shell.
The following sections provide information about other shells.

## ![cygwin](../images/cygwin-32.png) Installing Cygwin ##

The Cygwin software is a free and open source Linux implementation that runs on Windows.
The Cygwin shells can run Windows programs because Cygwin programs are compiled to run on Windows.
The Cygwin installation program will install `sh` and `bash` by default and additional shells and programs can be installed.
Cygwin is a very useful environment to increase productivity.  See:

* [Open Water Foundation / Learn Cygwin](http://learn.openwaterfoundation.org/owf-learn-cygwin/)
* [Cygwin](https://www.cygwin.com/) website

## Installing MinGW ##

MinGW is the GNU software project to provide a free and open source version of UNIX.
The Open Water Foundation does not typically install MinGW unless it is a part of another software tool
such as Git for Windows.
For example, if Git For Windows is installed, MinGW will be available in some form and therefore a command shell will be available.
See:

* [Minimalist GNU for Windows](http://www.mingw.org/)

## ![git](../images/git-bash-32.png) Installing Git for Windows (Git Bash) ##

Git for Windows is often installed by software developers and others who are using the Git version control system
to track versions of electronic files and collaborate with others on electronic file edits.
Git for Windows installs MinGW and Git Bash.  See:

* [Git](https://git-scm.com/) - select the ***Downloads*** link and then ***Windows***

## ![windows](../images/windows-32.png) Installing the Linux Subsystem on Windows 10 ##

Microsoft is now shipping a version of Linux within Windows to help developers.
The following explains how to enable/install the Linux Subsystem on Windows 10.

* [How to Install and Use the Linux Bash Shell on Windows 10](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/)
	+ As indicated above, after enabling the Windows Subsystem for Linux, visit the app store as indicated in the above instructions and
	install a version of Linux.  Ubuntu is recommended.
	+ As indicated above, after installing, specify a login and password that will be used in the Linux shell.
