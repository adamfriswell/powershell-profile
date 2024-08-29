#Aliases for commonly used programs
$debug = $false;
$username = "";
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias notion "C:\Users\$userName\AppData\Local\Programs\Notion\Notion.exe"
#oh-my-posh --init --shell pwsh | Invoke-Expression #--config "C:/Users/$username/oh-my-posh-config.json" | Invoke-Expression 

. "C:\Users\N19040\source\repos\powershell-profile\_scripts\fn_gitImport.ps1"

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
    $folders = Get-ChildItem -Path "." -Directory -Recurse | Where-Object { $_.Name -like "*-" }
    foreach($folder in $folders){
        $folderDirs = Get-ChildItem -Path $folder.Name -Directory | Where-Object { $_.Name -like "NewDay*" }
        $dirs += $folderDirs
    }

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
    git checkout - #$branch
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

# function nugetUpdate(){
#     # Get the .csproj file in the current directory
#     $csprojFile = Get-ChildItem -Path .\ -Filter *.csproj

#     # Fail if there isn't a .csproj file
#     if ($null -eq $csprojFile) {
#         Write-Error "No .csproj file found in the current directory."
#         # exit 1
#     }

#     # Load the .csproj file
#     [xml]$csproj = Get-Content -Path $csprojFile.FullName

#     # Get the list of packages and their versions
#     $packages = $csproj.Project.ItemGroup.PackageReference | ForEach-Object {
#         [PSCustomObject]@{
#             Package = $_.Include
#             Version = $_.Version
#         }
#     }

#     # Output the packages and their versions to the user
#     Write-Output "Packages in the project:"
#     $packages | ForEach-Object {
#         Write-Output "$($_.Package) [v$($_.Version)]"
#     }

#     Write-Output "--------------------------"

#     # # Ask the user which package they want to update
#     # $packageName = Read-Host -Prompt "Enter the package you want to update"

#     # # Get the list of versions for the selected package
#     # $versions = dotnet nuget list package $packageName --source "https://api.nuget.org/v3/index.json"

#     # # Output the versions to the user
#     # Write-Output "Available versions for $packageName :"
#     # Write-Output $versions

#     # # Ask the user which version they want to upgrade to
#     # $newVersion = Read-Host -Prompt "Enter the version you want to upgrade to"

#     # # Find the package reference for the package to update
#     # $packageReference = $csproj.Project.ItemGroup.PackageReference | Where-Object { $_.Include -eq $packageName }

#     # # Update the version
#     # $packageReference.Version = $newVersion

#     # # Save the .csproj file
#     # $csproj.Save($csprojFile.FullName)

#     # # Use dotnet restore to update the package
#     # dotnet restore
# }

#Install-PackageProvider -Name NuGet -Force

function nugetUpdate() {
    # Get the .csproj file in the current directory
    $csprojFile = Get-ChildItem -Path .\ -Filter *.csproj

    # Fail if there isn't a .csproj file
    if ($null -eq $csprojFile) {
        Write-Error "No .csproj file found in the current directory."
        return
    }

    # Load the .csproj file
    [xml]$csproj = Get-Content -Path $csprojFile.FullName

    # Get the list of packages and their versions
    $packages = @()
    $csproj.Project.ItemGroup | ForEach-Object {
        if ($_.PackageReference) {
            $_.PackageReference | ForEach-Object {
                $packages += [PSCustomObject]@{
                    Package = $_.Include
                    Version = $_.Version
                }
            }
        }
    }

    # Output the packages and their versions to the user
    Write-Output "Packages in the project:"
    $packages | ForEach-Object {
        Write-Output "$($_.Package) [v$($_.Version)]"
    }

    Write-Output "--------------------------"

    # Prompt the user to select a package to update
    $packageNames = $packages.Package
    $selectedPackage = $null
    while ($null -eq $selectedPackage) {
        $selectedPackage = Read-Host -Prompt "Enter the name of the package to update"
        if (-not $packageNames -contains $selectedPackage) {
            Write-Error "Invalid package name. Please try again."
            $selectedPackage = $null
        }
    }

    # Get the list of available versions for the selected package using the dotnet CLI
    $availableVersions = dotnet list package --include-prerelease --highest-minor --highest-patch | Select-String -Pattern $selectedPackage -Context 0,1 | ForEach-Object {
        $_.Context.PostContext[0]
    }

    if ($availableVersions.Count -eq 0) {
        Write-Error "No available versions found for package '$selectedPackage'."
        return
    }

    # Output the available versions to the user
    Write-Output "Available versions for package '$selectedPackage':"
    $availableVersions | ForEach-Object {
        Write-Output $_
    }

    Write-Output "--------------------------"

    # Prompt the user to select a new version from the list of available versions
    $newVersion = $null
    while ($null -eq $newVersion) {
        $newVersion = Read-Host -Prompt "Enter the new version for package '$selectedPackage' (choose from the list above)"
        if (-not $availableVersions -contains $newVersion) {
            Write-Error "Invalid version. Please try again."
            $newVersion = $null
        }
    }

    # Update the package using the dotnet CLI
    dotnet add package $selectedPackage --version $newVersion

    Write-Output "Updated '$selectedPackage' to version '$newVersion'."
}

function Get-NuGetPackageVersionsFromSolution {
    # Function to extract NuGet package references from a project file
    function Get-PackageReferences {
        param (
            [string]$ProjectFile
        )
        Get-Content $ProjectFile | Where-Object { $_ -match "PackageReference" } | ForEach-Object { ($_ -split '"')[1] }
    }

    # Function to extract project files from the solution file
    function Get-ProjectFiles {
        param (
            [string]$SolutionFile
        )
        Get-Content $SolutionFile | Where-Object { $_ -match "Project" } | ForEach-Object { $_.Split(",")[1].Trim() -replace '"|\\' }
    }

    # Find solution file in the current directory
    $solutionFiles = Get-ChildItem -Path . -Filter *.sln

    if ($solutionFiles.Count -eq 0) {
        Write-Host "No solution file found in the current directory."
        return
    }

    foreach ($solutionFile in $solutionFiles) {
        Write-Host "Processing solution file: $($solutionFile.FullName)"
        # Iterate over project files
        foreach ($projectFile in (Get-ProjectFiles $solutionFile.FullName)) {
            # Extract NuGet package references from each project file
            foreach ($packageReference in (Get-PackageReferences $projectFile)) {
                # List available versions for each package
                Write-Host "Available versions for package $packageReference"
                nuget search $packageReference
            }
        }
    }
}
