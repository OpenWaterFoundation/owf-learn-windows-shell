# Windows Shell / Useful Command Examples #

This page provides examples of useful Windows commands.
The commands can be run from the command line or used in a batch files.
See also [Useful Batch File Examples](../useful-batch-files/useful-batch-files.md).

* [Find the Locations of a Program](#find-the-locations-of-a-program)

--------------

## Find the Locations of a Program ##

It is useful to confirm which program is being run,
especially when multiple versions exist.
Use the [`where`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1)
program to search the `PATH` environment variable for all occurences of the program.
This is similar to the Linux [`which`](https://linux.die.net/man/1/which) command.
The name of the program to be found can be any executable program, with or without file extension.

```
> where cmd
C:\Windows\System32\cmd.exe
```
