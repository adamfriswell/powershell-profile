Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias vs-azurite "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator\azurite.exe"

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