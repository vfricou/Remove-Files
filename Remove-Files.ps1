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


# Grab the command line switches the script is called with
[CmdletBinding()]

param(

[int]$Days,
[string]$Path,
[string]$LogPath,
[string]$Filter,
[switch]$Files,
[switch]$Dirs,
[switch]$Recurse,
[switch]$WhatIf

)


# This Function Removes Files Only
Function RemoveFiles ($Days, $Path, $Filter, $Recurse, $Log) {

    $dateLimit = (Get-Date).AddDays(-$Days); # Set the number of days to delete files and folders by
    $count = 0

    Write-Verbose $dateLimit

    if ($Recurse) {
        $listFiles = Get-ChildItem -LiteralPath $Path -Filter $Filter -Recurse -File -Force| Where-Object CreationTime -lt $dateLimit
    }
    else {
        $listFiles = Get-ChildItem -LiteralPath $Path -Filter $Filter -File -Force| Where-Object CreationTime -lt $dateLimit
    }
    
    # Loop through all the files only
    foreach ($file in $listFiles) {
        
        $Created = ($file.CreationTime).ToString()
        $Name = $file.FullName
        
        Write-Verbose $Created
        Write-Verbose $Name

        if (!$WhatIf) {
            $file | Remove-Item -Force
        }

        if ($LogPath) {
            $LogEntry = $Created+" "+$Name
            if ($WhatIf) {
                $LogEntry = "***-WhatIf Parameter Used, File NOT Deleted*** "+$LogEntry
            }
            $LogEntry | Out-File -FilePath $Log -Append -Force
        }
    }

}

# This Function Removes Empty Folders Only
Function RemoveDirs ($Days, $Path, $Filter, $Log) {

    Write-Verbose $Path

    $dateLimit = (Get-Date).AddDays(-$Days);

    Write-Verbose $dateLimit
   
    $listDirs = Get-ChildItem -LiteralPath $Path -Filter $Filter -Directory -Force | Where-Object CreationTime -lt $dateLimit

    foreach ($Directory in $listDirs) {
        & RemoveDirs -Days $Days -Path $Directory.FullName -Log $LogFile
    }

    $DirChild = Get-ChildItem -LiteralPath $Path -Filter $Filter -Force

    if (!$DirChild) {

        $Created = (Get-Item -LiteralPath $Path -Force).CreationTime
        $Created = ($Created).ToString()

        Write-Verbose $Created
        Write-Verbose $Path
            
        if (!$WhatIf) {
            Remove-Item -LiteralPath $Path -Force
        }

        if ($LogPath) {
            $LogEntry = $Created+" "+$Path
            if ($WhatIf) {
                $LogEntry = "***-WhatIf Parameter Used, File NOT Deleted*** "+$LogEntry
            }
            $LogEntry | Out-File -FilePath $Log -Append -Force                
        }
    }

}


# Set some variables
$Verbose = $VerbosePreference -ne "SilentlyContinue" # Detect if the script was called with Verbose output
$curDate = Get-Date -Format dd-MM-yy_HHmm # Get the current date in specific format (to set the log file name)
if ($LogPath) { # If the LogPath Command Line switch is set, then we want a log file
    $LogFile = $LogPath+"FileCleanup_"+$curDate+".log"
}

if (!$Files -and !$Dirs) {
    $Files = $true
    $Dirs = $true
}

if (!$Filter) {
    $Filter = ""
}

if ($Files) {
    if ($Recurse) {
        RemoveFiles -Days $Days -Path $Path -Filter $Filter -Recurse $true -Log $LogFile # Call the RemoveFiles function with recurse
    }
    else {
        RemoveFiles -Days $Days -Path $Path -Filter $Filter -Log $LogFile # Call the RemoveFiles function
    }
}
if ($Dirs) {
    RemoveDirs -Days $Days -Path $Path -Filter $Filter -Log $LogFile # Call the RemoveDirs function
}

# Write out set variables when script is called with Verbose output
Write-Verbose $Days
Write-Verbose $Path
Write-Verbose $Filter
Write-Verbose $LogPath
Write-Verbose $curDate
Write-Verbose $logFile
Write-Verbose $Verbose
Write-Verbose $WhatIf