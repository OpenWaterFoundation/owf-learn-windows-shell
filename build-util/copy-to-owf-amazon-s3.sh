#!/bin/sh
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is required
# The above line ensures that the script can be run on Cygwin/Linux even with Windows CRNL
#
# Copy the site/* contents to the learn.openwaterfoundation.org website
# - replace all the files on the web with local files
# - must specify Amazon profile as argument to the script

# Supporting functions, alphabetized

# Make sure the MkDocs version is consistent with the documentation content
# - require that at least version 1.0 is used because of use_directory_urls = True default
# - must use "file.md" in internal links whereas previously "file" would work
# - it is not totally clear whether version 1 is needed but try this out to see if it helps avoid broken links
checkMkdocsVersion() {
	# Required MkDocs version is at least 1
	requiredMajorVersion="1"
	# On Cygwin, mkdocs --version gives:  mkdocs, version 1.0.4 from /usr/lib/python3.6/site-packages/mkdocs (Python 3.6)
	# On Debian Linux, similar to Cygwin:  mkdocs, version 0.17.3
	if [ "$operatingSystem" = "cygwin" -o "$operatingSystem" = "linux" ]; then
		mkdocsVersionFull=$(mkdocs --version)
	elif [ "$operatingSystem" = "mingw" ]; then
		mkdocsVersionFull=$(py -m mkdocs --version)
	else
		echo ""
		echo "Don't know how to run on operating system $operatingSystem"
		exit 1
	fi
	echo "MkDocs --version:  $mkdocsVersionFull"
	mkdocsVersion=$(echo $mkdocsVersionFull | cut -d ' ' -f 3)
	echo "MkDocs full version number:  $mkdocsVersion"
	mkdocsMajorVersion=$(echo $mkdocsVersion | cut -d '.' -f 1)
	echo "MkDocs major version number:  $mkdocsMajorVersion"
	if [ "$mkdocsMajorVersion" -lt $requiredMajorVersion ]; then
		echo ""
		echo "MkDocs version for this documentation must be version $requiredMajorVersion or later."
		echo "MkDocs mersion that is found is $mkdocsMajorVersion, from full version ${mkdocsVersion}."
		exit 1
	else
		echo ""
		echo "MkDocs major version ($mkdocsMajorVersion) is OK for this documentation."
	fi
}

# Determine the operating system that is running the script
# - mainly care whether Cygwin or MINGW
checkOperatingSystem()
{
	if [ ! -z "${operatingSystem}" ]; then
		# Have already checked operating system so return
		return
	fi
	operatingSystem="unknown"
	os=`uname | tr [a-z] [A-Z]`
	case "${os}" in
		CYGWIN*)
			operatingSystem="cygwin"
			;;
		LINUX*)
			operatingSystem="linux"
			;;
		MINGW*)
			operatingSystem="mingw"
			;;
	esac
}

# Check the source files for issues
# - the main issue is internal links need to use [](file.md), not [](file)
checkSourceDocs() {
	# Currently don't do anything but could check the above
	# Need one line to not cause an error
	:
}

# Entry point into the script

# Check the operating system
checkOperatingSystem

# Make sure the MkDocs version is OK
checkMkdocsVersion

# Check the source files for issues
checkSourceDocs

# Get the folder where this script is located since it may have been run from any folder
scriptFolder=$(cd $(dirname "$0") && pwd)
# Change to the folder where the script is since other actions below are relative to that
cd ${scriptFolder}

# Set --dryrun to test before actually doing
dryrun=""
#dryrun="--dryrun"

s3Folder="s3://learn.openwaterfoundation.org/owf-learn-windows-shell"

if [ "$1" == "" ]
	then
	echo ""
	echo "Usage:  $0 AmazonConfigProfile"
	echo ""
	echo "Copy the site files to the Amazon S3 static website folder:  $s3Folder"
	echo ""
	exit 0
fi

awsProfile="$1"

# First build the site so that the "site" folder contains current content.
# - "mkdocs serve" does not do this

cd ../mkdocs-project
if [ "$operatingSystem" = "cygwin" -o "$operatingSystem" = "linux" ]; then
	mkdocs build --clean
elif [ "$operatingSystem" = "mingw" ]; then
	# This is used by Git Bash
	py -m mkdocs build --clean
fi
cd ../build-util

# Now sync the local files up to Amazon S3
if [ "$operatingSystem" = "mingw" ]; then
	# If "aws" is in path, run it
	if [ "$(which aws 2> /dev/null | cut -c 1)" = "/" ]; then
		# Found aws
		aws s3 sync ../mkdocs-project/site ${s3Folder} ${dryrun} --delete --profile "$awsProfile"
	else
		# Figure out the Python installation path
		pythonExePath=$(py -c "import sys; print(sys.executable)")
		if [ -n "$pythonExePath" ]; then
			# Path will be something like:  C:\Users\sam\AppData\Local\Programs\Python\Python37\python.exe
			# - so strip off the exe and substitute Scripts
			# - convert the path to posix first
			pythonExePathPosix="/$(echo $pythonExePath | sed 's/\\/\//g' | sed 's/://')"
			pythonScriptsFolder="$(dirname $pythonExePathPosix)/Scripts"
			echo $pythonScriptsFolder
			$pythonScriptsFolder/aws s3 sync ../mkdocs-project/site ${s3Folder} ${dryrun} --delete --profile "$awsProfile"
		else
			echo "ERROR: Unable to find Python installation location to find 'aws' script"
			echo "ERROR: Make sure Python 3.x is installed on Windows so 'py' is available in PATH"
		fi
	fi
else
	# For other Linux just try to run
	aws s3 sync ../mkdocs-project/site ${s3Folder} ${dryrun} --delete --profile "$awsProfile"
fi

exit $?
