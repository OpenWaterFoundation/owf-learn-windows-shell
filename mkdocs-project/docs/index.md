# Learn / Windows Shell #

This documentation provides resources to learn how to use the Windows shell
([`cmd`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cmd) program),
which provides an interactive command line environment and ability to automate tasks with batch files.
The term "batch file" is used rather than "shell script", which is typically used with Linux,
because of the Windows convention to name files with `.bat` file extension.
See also [batch files on Wikipedia](https://en.wikipedia.org/wiki/Batch_file).

Particular care has been taken in this documentation to explain the Window shell and batch
files for programmers that may be familiar with Linux shell scripting.
In some cases, it may make sense to call a Linux shell script from a Windows batch file,
for example if programming equivalent functionality in a batch file is challenging.
See the following resources:

* Open Water Foundation [Learn / Linux Shell](http://learn.openwaterfoundation.org/owf-learn-linux-shell/) learning resources
* Open Water Foundation [Learn / Cygwin](http://learn.openwaterfoundation.org/owf-learn-cygwin/) learning resources

Windows batch files are useful for memorializing processing workflows and automating repetitive tasks on Windows computers.
The Windows command shell program  has been available on many generations of personal computers and
previous to Windows was used on [MS-DOS operating system](https://en.wikipedia.org/wiki/MS-DOS).
Consequently, the functionality of the `cmd` program and batch file syntax
are influenced by this long history and need to support running old batch files.
Additionally, new functionality has been added over time.
The combination of old and new functionality can lead to confusion determining the best approach
when creating batch files.

The alternative to batch files on Windows is
[PowerShell scripts](https://en.wikipedia.org/wiki/PowerShell),
which are not discussed in this documentation except when comparison is enlightening.
PowerShell is primarily used on servers and often requires special authentication,
whereas batch files are prevalent on desktop computers for typical users and tasks.

Using a Linux shell on Windows computers is another alternative
(see links to Linux and Cygwin learning resources above).
However, in many cases, using batch files on Windows is preferred or is required,
for example when Linux shells software is not installed.

More advanced programming can be performed with other languages.
Python is recommended given its ease of use, popularity, and functionality.
However, even when a programming language could be used to write a software program,
the shell program is still useful for ad hoc tasks and tasks that
integrate closely with the Windows operating system.

This documentation has been written based on experience using the Windows shell at the Open Water Foundation.

## About the Open Water Foundation ##

The [Open Water Foundation](http://openwaterfoundation.org) is a nonprofit social enterprise that focuses
on developing and supporting open source software for water resources,
so that organizations can make better decisions about water.
OWF also works to advance open data tools and implementation.
OWF has created this documentation to educate its staff, collaborators, and clients that use Linux shells.

See also other [OWF learning resources](http://learn.openwaterfoundation.org).

## How to Use this Documentation ##

The documentation is organized in order of information and tasks necessary to create and use `cmd` program batch files,
including learning about batch file programming, useful commands, and useful script examples.

This documentation is not intended to be a full reference for Windows shell but focuses on topics that
will help understand important technical concepts and be successful with Windows shell.
See the [Resources section](../resources/resources) for general information.

Use the navigation menu provided on the left side of the page to navigate the documentation sections within the full document.
Use the navigation menu provided on the right side of the page to navigate the documentation sections with a page.
The navigation menus may not be displayed if the web browser window is narrow or if viewing on a mobile device,
in which case look for a menu icon to access the menus.
Use the search feature to find documentation matching search words.

## License ##

The OWF Learn Windows Shell website content and examples are licensed under the
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0).

## Source Repository on GitHub ##

The source files for this documentation are maintained in a GitHub repository:
[owf-learn-windows-shell](https://github.com/OpenWaterFoundation/owf-learn-windows-shell).

## Release Notes ##

See the [GitHub issues](https://github.com/OpenWaterFoundation/owf-learn-windows-shell/issues) for changes.
