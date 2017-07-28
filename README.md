# Remove-Files
Powershell - Remove Files and/or Folders recursivly older than x number of days

# Script to remove files and folders older than x number of days
#
# Name: Remove-Files.ps1
# Version: 1.0
# Date: 17/07/2017
#
# Script Arguments:
#
# -Days x  // REQUIRED - Set the age of files/folders to be removed
# -Path Drive:\Path\  // REQUIRED - Set the root path the script should remove files/folders from
# -LogPath Drive:\Path\ // OPTIONAL - Set a path to output a log file to
# -Files  // OPTIONAL - Only remove files
# -Dirs  // OPTIONAL - Only remove empty directories
#
# ***NOTE: The absence of -Files or -Dirs is the same as specifying both***
#
# -Recurse  // OPTIONAL - Delete files recursively (Note: directory cleanup is always recursive)
# -Filter  // OPTIONAL - Set a string filter to search for, this applies to both Files and Folders
# -WhatIf  // OPTIONAL - Log/Output what would be deleted/removed, without actually deleting/removing
# -Verbose  // OPTIONAL - Show debug/verbose output at console
