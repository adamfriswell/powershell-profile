#delete all child bin + obj folders
function DeleteBinObj(){
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

function lint(){
    .\dotnet-format.cmd
    git add . 
    git commit -m "lint"
    git push
}