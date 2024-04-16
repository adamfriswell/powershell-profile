#Aliases for commonly used programs
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias notion "C:\Users\{username}\AppData\Local\Programs\Notion\Notion.exe"

#Test if console is in admin mode
function IsAdmin(){
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function FindFile($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}

function FindPort($port){
    netstat -ano | findstr :$port
}

function KillPort($processId){
    taskkill /PID $processId /F
}

function SetAliasIfExists($name, $value){
    $debug = $true;
    if($debug){
        $output = "$name = $value"
        $output = $output -replace "`n", "" -replace "`r", ""
        Write-Output $output
    }

    if (!(Get-Alias -Name $name -ErrorAction SilentlyContinue)) {
        $scriptBlock = [scriptblock]::Create($value)
        Set-Item -Path function:global:$name -Value $scriptBlock
    } else {
        Write-Warning "Alias $name already exists."
    }
}

#github copilot generated
function New-RepoAliases {
    $dirs = Get-ChildItem -Path "." -Directory | Where-Object { $_.Name -like "NewDay*" }

    foreach ($dir in $dirs) {
        $parts = $dir.Name.Split('.')
        $aliasName = ""
        for ($i = $parts.Length - 1; $i -ge 0; $i--) {
            if ($parts[$i] -eq "NewDay" -or ($i -eq 1 -and ($parts[$i] -eq "ClosedLoop" -or $parts[$i] -eq "Stratus"))) {
                continue
            }
            if ($i -eq 1 -and $parts[$i] -eq "Example") {
                $aliasPart = "ex-"
            } else {
                if ($parts[$i] -eq "EgressService") {
                    $aliasPart = "egrs"
                } elseif ($parts[$i] -eq "IngressService") {
                    $aliasPart = "igrs"
                } else {
                    $aliasPart = [string]::Join("", ([char[]]($parts[$i]) | Where-Object { $_ -cmatch "[A-Z]" })).ToLower()
                    if ($parts[$i] -eq "MultiTenancy" -or $parts[$i] -eq "RegularPayments") {
                        $aliasPart += "-"
                    }
                    if ($aliasPart.Length -eq 1 -and $parts[$i] -notin @("Core", "Platform", "Egress", "Ingress", "Fiserv", "Content", "Infra", "Spike", "Perimeter", "Docs", "Service", "Api", "Common", "Templates")) {
                        $aliasPart = $parts[$i].Substring(0, [Math]::Min(3, $parts[$i].Length)).ToLower()
                    }
                    if ($i -eq 1 -and ($parts[$i] -eq "AccountManagement" -or $parts[$i] -eq "TenancyManagement")) {
                        $aliasPart += "s-"
                    }
                    if ($parts[$i] -eq "HubSpoke") {
                        $aliasPart = "-" + $aliasPart
                    }
                }
            }
            $aliasName = $aliasPart + $aliasName
        }

        $repoAliasName = "r-" + $aliasName
        $directoryAliasName = "d-" + $aliasName

        $slnFile = Get-ChildItem -Path $dir.FullName -Filter "*.sln" -Recurse | Select-Object -First 1
        $repoAliasValue = if ($slnFile) { "cd $($slnFile.DirectoryName); Invoke-Item $($slnFile.FullName)" } else { "cd $($dir.FullName); code ." }

        SetAliasIfExists $repoAliasName $repoAliasValue
        SetAliasIfExists $directoryAliasName "cd $($dir.FullName)"
    }
}
New-RepoAliases

function UnpinApp([string]$appname) {
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() |
        Where-Object{$_.Name -eq $appname}).Verbs() | 
        Where-Object{$_.Name.replace('&','') -match 'Unpin from taskbar'} | 
        ForEach-Object{$_.DoIt()}
}
#unpin unwanted apps from taskbar that company policy enforces
UnpinApp Word
UnpinApp Outlook
UnpinApp Powerpoint
UnpinApp Excel
UnpinApp OneDrive
UnpinApp "Cisco AnyConnect Secure Mobility Client"
UnpinApp "Microsoft Edge"
UnpinApp "Google Chrome"

function CosmosDbNotStartingOnLocalHostFix(){
    #from https://stackoverflow.com/questions/62210493/azure-cosmos-db-emulator-not-running-it-starts-and-then-throws-error/62236663#62236663
    lodctr /R
    c:\Windows\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe -i
    lodctr /R
}

#gmp = git main pull
function gmp($branch){
    git checkout main
    git pull
    if($branch){
        git checkout -b $branch
    }
}

#gmm = git main merge
function gmm(){
    $branch = git rev-parse --abbrev-ref HEAD
    git checkout main
    git pull
    git checkout $branch
    git merge main
    git add .
    git push
}

## --------- dotnet related functions ---------

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