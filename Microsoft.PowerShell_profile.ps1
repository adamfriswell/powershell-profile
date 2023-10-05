#Aliases for commonly used programs
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias notion "C:\Users\{your username here}\AppData\Local\Programs\Notion\Notion.exe"

#Test if console is in admin mode
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

#function to generate aliases for each repo that contains a dotnet solution file
function generateRepoAliases(){
    $root = "C:\Users\{username}\source\repos" #or wherever you store your repos
    Write-Host "Creating aliases..."
    $count = 0
    get-childitem $root -recurse | where {$_.extension -eq ".sln"} | % {
        $count = $count + 1
        $path = $_.FullName
        $solutionName = $path.Split("\")[5]
        $capitals = $solutionName -creplace '[^A-Z]'
        $aliasShortcut = $capitals.ToLower()

        Write-Host "Set-Alias $aliasShortcut $path"
    }
    Write-Host "$count alises created"
}

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
