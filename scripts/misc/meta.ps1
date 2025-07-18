. $PSScriptRoot\..\variables.ps1

<#
.SYNOPSIS
    Generate a PowerShell function from an existing script file
#>
function powershellMetaConvertOtherScriptsToFunctions() {
    # Define the path to the .ps1 file
    $userName = "YOUR USERNAME"
    $path = "C:\Users\$username\OneDrive - NewDay Cards Ltd\Documents\_scripts"
    $files = @("gitImport.ps1") #, "nuget.ps1")

    foreach ($file in $files) {
        $filePath = "$path\$file"

        # Get the file name without extension
        $functionName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)

        # Read the contents of the .ps1 file
        $fileContent = Get-Content -Path $filePath -Raw

        # Create the function definition
        $functionDefinition = @'
   function $functionName {
        $fileContent
    }
'@ -f $functionName, $fileContent

        # Output the function definition to a new .ps1 file or to the console
        # To save to a new file:
        $outputFilePath = "$path\function_$functionName.ps1"
        $functionDefinition | Out-File -FilePath $outputFilePath
    }
}

<#
.SYNOPSIS
    Lists all functions defined in the PowerShell profile repository.
.DESCRIPTION
    Scans all .ps1 files in the repository and extracts function names to provide a quick reference.
    Results are ordered by file name, then function name.
#>
function fnHelp {
    # Get the path to the repository
    $repoPath = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
    
    # Find all .ps1 files
    $psFiles = Get-ChildItem -Path $repoPath -Filter "*.ps1" -Recurse -File
    
    # Initialize collection for function names
    $functions = @()
    
    # More precise regex pattern for function definitions
    # Matches 'function' keyword followed by space and function name
    $functionPattern = '(?<=^|\s)function\s+([a-zA-Z0-9_-]+)(?=\s*{|\s*\()'
    
    foreach ($file in $psFiles) {
        $content = Get-Content -Path $file.FullName -Raw
        $foundMatches = [regex]::Matches($content, $functionPattern)
        
        foreach ($match in $foundMatches) {
            $functionName = $match.Groups[1].Value
            $relativePath = $file.FullName.Replace($repoPath, "").TrimStart("\")
            $help = Get-Help $functionName -ErrorAction SilentlyContinue
            $synopsis = if ($help -and $help.Synopsis) { $help.Synopsis } else { "" }
            $functions += [PSCustomObject]@{
                Name = $functionName
                File = $relativePath
                Synopsis = $synopsis
            }
        }
    }
    
    # Display results ordered by file then function name
    Write-Host "Available Functions:" -ForegroundColor Cyan
    
    # First sort the functions collection
    $sortedFunctions = $functions | Sort-Object File, Name
    
    # Then display as a table
    $sortedFunctions | Format-Table -AutoSize
}