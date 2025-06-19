. $PSScriptRoot\..\git\generalGit.ps1

<#
.SYNOPSIS
    Delete all child bin + obj folders
#>
function deleteBinObj(){
    Get-ChildItem .\ -include bin,obj -Recurse | ForEach-Object ($_) { remove-item $_.fullname -Force -Recurse }
}

<#
.SYNOPSIS
    Pre-commit hook to run dotnet format
#>
function dotnetformat() {
    mapSysLinkForPreCommit "pre-commit"
}

<#
.SYNOPSIS
    Pre-commit hook to run dotnet format for whitespaces
#>
function dotnetformatwhitespace() {
    mapSysLinkForPreCommit "pre-commit-whitespace"
}

<#
.SYNOPSIS
    Maps a syslink to enable pre-commit hook
#>
function mapSysLinkForPreCommit([string]$fileName){
    $mapping = @{
        dest   = "c:\bash hooks\" + $filename
        source = "$PWD\.git\hooks\pre-commit"
    }
    Write-Output "Creating symlink for $($mapping.source) -> $($mapping.dest)"
  
    if (Test-Path -Path $mapping.source) {
        $(Get-Item $mapping.source).Delete()
    }
  
    New-Item `
        -ItemType SymbolicLink `
        -Path $mapping.source -Target $mapping.dest
}

<#
.SYNOPSIS
    Runs dotnetformat.cmd/ps1 and commits the changes
#>
function lint() {
    if (Test-Path ".\dotnet-format.cmd") {
        .\dotnet-format.cmd
    } elseif (Test-Path ".\dotnet-format.ps1") {
        .\dotnet-format.ps1
    } else {
        Write-Host "Neither dotnet-format.cmd nor dotnet-format.ps1 found."
        return
    }
    
    yeet -m "lint"
}