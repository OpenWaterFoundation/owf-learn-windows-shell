#!/bin/sh
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is required
# The above line ensures that the script can be run on Cygwin/Linux even with Windows CRNL
#
# Run 'mkdocs serve' on port 8000 (default) for MkDocs 1.x.
#
# The most recent version of this script is saved with Open Water Foundation owf-learn-mkdocs GitHub repository.
# If changes are implemented, the version in owf-learn-mkdocs/build-util should be updated as the global master.
# If necessary, run 'dos2unix' or 'unix2dos' (or equivalent) to ensure that line endings are OK in the copied script.
#
# -------------------------------------------------------------------------------------------------------------
# This script attempts to find a suitable Python and mkdocs module for cygwin, Git bash, and Linux.
# The script is assumed to be installed in one of two configurations, for example:
#
# Option 1 - repository is dedicated to the documentation:
#
# main-repo-folder/
#   mkdocs-project/
#     mkdocs.yml
#   build-util/
#     this-script
#   doc/
#   site/
#
# Option 2 - repository contains more than the documentation and documentation is in a top-level folder,
# for example:
#
# main-repo-folder/
#   doc-dev-mkdocs-project/
#     mkdocs.yml
#     build-util/
#       this-script
#     doc/
#     site/
#
# In either case, a standard MkDocs folder structure is assumed with 'mkdocs.yml' configuration file,
# 'docs/' folder for source files, and 'site/' folder for MkDocs-generated static website.
# -------------------------------------------------------------------------------------------------------------

# Supporting functions, alphabetized

# Check the folder depth for the MkDocs project
# - the folder where this script lives may be at various levels relative to the main MkDocs project folder
# - depends on "scriptFolder" having been set
checkFolderDepth() {
	folderDepth=999
	if [ -e "${scriptFolder}/../mkdocs-project/mkdocs.yml" ]; then
		folderDepth=1
	elif [ -e "${scriptFolder}/../../mkdocs-project/mkdocs.yml" ]; then
		folderDepth=2
	fi
}

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
	echo "Detected operating system:  ${operatingSystem}"
}

# Check the source files for issues
# - the main issue is internal links need to use [](file.md), not [](file)
checkSourceDocs() {
	# Currently don't do anything but could check the above
	# Need one line to not cause an error
	:
}

# Entry point into the script

# Get the folder where this script is located since it may have been run from any folder
scriptFolder=`cd $(dirname "$0") && pwd`
# Change to the folder where the script is since other actions below are relative to that
cd ${scriptFolder}

# Check the operating system
checkOperatingSystem

# Make sure the MkDocs version is OK
checkMkdocsVersion

# Check the source files for issues
checkSourceDocs

# Determine if this script is one or two folders under MkDocs project folder
checkFolderDepth

# Change to the MkDocs project folder so that 'mkdocs' can be run and find files it expects.
if [ ${folderDepth} -eq 1 ]; then
	cd ../mkdocs-project
elif [ ${folderDepth} -eq 2 ]; then
	cd ../../mkdocs-project
else
	echo "Folder structure does not match expected 'mkdocs-project'.  Exiting."
	exit 1
fi

# Run 'mkdocs serve' using an appropriate variation of Python command line.
echo "View the website using http://localhost:8000"
echo "Stop the server with CTRL-C"
if [ "$operatingSystem" = "cygwin" -o "$operatingSystem" = "linux" ]; then
	# For cygwin and linux, 'mkdocs' will probably be in the PATH
	echo "On Cygwin and Linux... running 'mkdocs serve...'"
	mkdocs serve -a 0.0.0.0:8000
elif [ "$operatingSystem" = "mingw" ]; then
	# This is used by Git Bash
	echo "On MinGW (Git Bash) ... running 'py -m mkdocs serve...'"
	py -m mkdocs serve -a 0.0.0.0:8000
fi

# Exiting the script will return to the starting folder
