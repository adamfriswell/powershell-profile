#Aliases for commonly used programs
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias notion "C:\Users\{username}\AppData\Local\Programs\Notion\Notion.exe"

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

# function createRepoAliasFunctions(){
#     Set-Variable -name meod -value 'function meod(){ Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.MerchantEndOfDayService
#     C:\Users\N19040\source\repos\NewDay.ClosedLoop.MerchantEndOfDayService\NewDay.ClosedLoop.MerchantEndOfDayService.sln}' -scope global

#     Invoke-Expression $meod
#     $meod
# }

# function setAliasAndCd([cmdlet]$path, [cmdlet]$sln){
#     $dir = $path + "/" + $sln
#     Set-Location -Path $path
#     $dir
# }


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
                    $aliasPart = "eeg"
                } elseif ($parts[$i] -eq "IngressService") {
                    $aliasPart = "ing"
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

        $aliasName = "r-" + $aliasName

        $slnFile = Get-ChildItem -Path $dir.FullName -Filter "*.sln" -Recurse | Select-Object -First 1
        $aliasValue = if ($slnFile) { "cd $($slnFile.DirectoryName); Invoke-Item $($slnFile.FullName)" } else { "cd $($dir.FullName); code ." }

        ##DEBUG
        # $output = "$aliasName = $aliasValue"
        # $output = $output -replace "`n", "" -replace "`r", ""
        # Write-Output $output

        if (!(Get-Alias -Name $aliasName -ErrorAction SilentlyContinue)) {
            $scriptBlock = [scriptblock]::Create($aliasValue)
            Set-Item -Path function:global:$aliasName -Value $scriptBlock
        } else {
            Write-Warning "Alias $aliasName already exists."
        }
    }
}
New-RepoAliases

function ci(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.Core.Infra
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.Core.Infra\NewDay.ClosedLoop.Core.Infra.sln
}
function pi(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.Perimeter.Infra
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.Perimeter.Infra\NewDay.ClosedLoop.Perimeter.Infra.sln
}
function mgs(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.MerchantGatewayService
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.MerchantGatewayService\NewDay.ClosedLoop.MerchantGatewayService.sln
}
function ss(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.SettlementService
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.SettlementService\NewDay.ClosedLoop.SettlementService.sln
}
function os(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.OfferService
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.OfferService\NewDay.ClosedLoop.OfferService.sln
}
function rcs(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.RateCardService
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.RateCardService\NewDay.ClosedLoop.RateCardService.sln
}
function meod(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.MerchantEndOfDayService
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.MerchantEndOfDayService\NewDay.ClosedLoop.MerchantEndOfDayService.sln
}
function eeg(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.EgressService
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.EgressService\NewDay.ClosedLoop.EgressService.sln
}
function iig(){
    Set-Location -Path C:\Users\N19040\source\repos\NewDay.ClosedLoop.IngressService
    C:\Users\N19040\source\repos\NewDay.ClosedLoop.IngressService\NewDay.ClosedLoop.IngressService.sln
}

#gmp = git main pull
function gmp($branch){
    git checkout main
    git pull
    if($branch){
        git checkout -b $branch
    }

}

#function to generate aliases for each repo that contains a dotnet solution file
function generateRepoAliases(){
    $root = "C:\Users\{username}\source\repos"
    Write-Host "Creating aliases..."
    $count = 0
    get-childitem $root -recurse | where {$_.extension -eq ".sln"} | % {
        $count = $count + 1
        $path = $_.FullName
        $solutionName = $path.Split("\")[5]
        $capitals = $solutionName -creplace '[^A-Z]'
        $aliasShortcut = $capitals.ToLower()

        Write-Host $aliasShortcut "=" $path 
        # Set-Alias $aliasShortcut $path
    }
    Write-Host "$count alises created"
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