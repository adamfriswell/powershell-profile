#Aliases for commonly used programs
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias notion "C:\Users\{your username here}\AppData\Local\Programs\Notion\Notion.exe"

#Test if consol is in admin mode
function isadmin(){
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function findfile($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}

## dotnet related functions

#delete all child bin + obj folders
function deletebinobj(){
    Get-ChildItem .\ -include bin,obj -Recurse | ForEach-Object ($_) { remove-item $_.fullname -Force -Recurse }
}

#pre-commit hook to run dotnet format
function dotnetformat() {
    mapSysLinkForPreCommit "pre-commit"
}

#pre-commit hook to run dotnet format for whitespaces
function dotnetformatwhitespace() {
    mapSysLinkForPreCommit "pre-commit-whitespace"
}

#maps a syslink to enable pre-commit hook
function mapSysLinkForPreCommit([string]$fileName){
    $mapping = @{
        dest   = "c:\dev\" + $filename
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
