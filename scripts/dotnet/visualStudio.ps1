<#
.SYNOPSIS
    Open Visual Studio solution
#>
function openSln {
    $solutionFile = Get-ChildItem -Path . -Filter *.sln | Select-Object -First 1
    
    if ($solutionFile) {
        & vs $solutionFile.FullName
    } else {
        Write-Host "No solution file found in current directory."
    }
}