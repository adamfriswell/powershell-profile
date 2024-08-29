########### INITAL ATTEMPTS #############

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

# function nugetUpdate() {
#     # Get the .csproj file in the current directory
#     $csprojFile = Get-ChildItem -Path .\ -Filter *.csproj

#     # Fail if there isn't a .csproj file
#     if ($null -eq $csprojFile) {
#         Write-Error "No .csproj file found in the current directory."
#         return
#     }

#     # Load the .csproj file
#     [xml]$csproj = Get-Content -Path $csprojFile.FullName

#     # Get the list of packages and their versions
#     $packages = @()
#     $csproj.Project.ItemGroup | ForEach-Object {
#         if ($_.PackageReference) {
#             $_.PackageReference | ForEach-Object {
#                 $packages += [PSCustomObject]@{
#                     Package = $_.Include
#                     Version = $_.Version
#                 }
#             }
#         }
#     }

#     # Output the packages and their versions to the user
#     Write-Output "Packages in the project:"
#     $packages | ForEach-Object {
#         Write-Output "$($_.Package) [v$($_.Version)]"
#     }

#     Write-Output "--------------------------"

#     # Prompt the user to select a package to update
#     $packageNames = $packages.Package
#     $selectedPackage = $null
#     while ($null -eq $selectedPackage) {
#         $selectedPackage = Read-Host -Prompt "Enter the name of the package to update"
#         if (-not $packageNames -contains $selectedPackage) {
#             Write-Error "Invalid package name. Please try again."
#             $selectedPackage = $null
#         }
#     }

#     # Get the list of available versions for the selected package using the dotnet CLI
#     $availableVersions = dotnet list package --include-prerelease --highest-minor --highest-patch | Select-String -Pattern $selectedPackage -Context 0,1 | ForEach-Object {
#         $_.Context.PostContext[0]
#     }

#     if ($availableVersions.Count -eq 0) {
#         Write-Error "No available versions found for package '$selectedPackage'."
#         return
#     }

#     # Output the available versions to the user
#     Write-Output "Available versions for package '$selectedPackage':"
#     $availableVersions | ForEach-Object {
#         Write-Output $_
#     }

#     Write-Output "--------------------------"

#     # Prompt the user to select a new version from the list of available versions
#     $newVersion = $null
#     while ($null -eq $newVersion) {
#         $newVersion = Read-Host -Prompt "Enter the new version for package '$selectedPackage' (choose from the list above)"
#         if (-not $availableVersions -contains $newVersion) {
#             Write-Error "Invalid version. Please try again."
#             $newVersion = $null
#         }
#     }

#     # Update the package using the dotnet CLI
#     dotnet add package $selectedPackage --version $newVersion

#     Write-Output "Updated '$selectedPackage' to version '$newVersion'."
# }

# function Get-NuGetPackageVersionsFromSolution {
#     # Function to extract NuGet package references from a project file
#     function Get-PackageReferences {
#         param (
#             [string]$ProjectFile
#         )
#         Get-Content $ProjectFile | Where-Object { $_ -match "PackageReference" } | ForEach-Object { ($_ -split '"')[1] }
#     }

#     # Function to extract project files from the solution file
#     function Get-ProjectFiles {
#         param (
#             [string]$SolutionFile
#         )
#         Get-Content $SolutionFile | Where-Object { $_ -match "Project" } | ForEach-Object { $_.Split(",")[1].Trim() -replace '"|\\' }
#     }

#     # Find solution file in the current directory
#     $solutionFiles = Get-ChildItem -Path . -Filter *.sln

#     if ($solutionFiles.Count -eq 0) {
#         Write-Host "No solution file found in the current directory."
#         return
#     }

#     foreach ($solutionFile in $solutionFiles) {
#         Write-Host "Processing solution file: $($solutionFile.FullName)"
#         # Iterate over project files
#         foreach ($projectFile in (Get-ProjectFiles $solutionFile.FullName)) {
#             # Extract NuGet package references from each project file
#             foreach ($packageReference in (Get-PackageReferences $projectFile)) {
#                 # List available versions for each package
#                 Write-Host "Available versions for package $packageReference"
#                 nuget search $packageReference
#             }
#         }
#     }
# }

















################# Attempt3 ####################
# Get the .csproj file in the current directory
    $csprojFile = Get-ChildItem -Path .\ -Filter *.csproj

    # Fail if there isn't a .csproj file
    if ($null -eq $csprojFile) {
        Write-Error "No .csproj file found in the current directory."nuget
        exit 1
    }

    # Load the .csproj file
    [xml]$csproj = Get-Content -Path $csprojFile.FullName

    # Get the list of packages
    $packages = $csproj.Project.ItemGroup.PackageReference | ForEach-Object { $_.Include }

    # Output the packages to the user
    Write-Output "Packages in the project:"
    $packages | ForEach-Object { Write-Output $_ }

    # # Ask the user which package they want to update
    # $packageName = Read-Host -Prompt "Enter the package you want to update"

    # # Get the list of versions for the selected package
    # $versions = dotnet nuget list package $packageName --source "https://api.nuget.org/v3/index.json"

    # # Output the versions to the user
    # Write-Output "Available versions for $packageName :"
    # Write-Output $versions

    # # Ask the user which version they want to upgrade to
    # $newVersion = Read-Host -Prompt "Enter the version you want to upgrade to"

    # # Find the package reference for the package to update
    # $packageReference = $csproj.Project.ItemGroup.PackageReference | Where-Object { $_.Include -eq $packageName }

    # # Update the version
    # $packageReference.Version = $newVersion

    # # Save the .csproj file
    # $csproj.Save($csprojFile.FullName)

    # # Use dotnet restore to update the package
    # dotnet restore




################# Attempt4 ####################

# Find the .csproj file in the current directory
$rootPath = "C:\Users\YOUR_USERNAME\source\repos\NewDay.ClosedLoop.MerchantGatewayService"
$csprojFiles = Get-ChildItem -Path $path -Filter *.csproj #-Recurse

# Check if a .csproj file was found
if ($csprojFiles.Count -eq 0) {
    Write-Host "Nasdasdasdasdo .csproj file(s) found in the current directory."
}

foreach ($csprojFile in $csprojFiles){
        
    # Load the .csproj file content
    [xml]$csprojContent = Get-Content $csprojFile.FullName

    # Find all PackageReference elements
    $packageReferences = $csprojContent.Project.ItemGroup.PackageReference

    # Check if there are any PackageReference elements
    if ($packageReferences -eq $null) {
        Write-Host "No NuGet packages found in the .csproj file."
    }

    # Output the package references
    $packages = @()
    foreach ($package in $packageReferences) {
        $packageName = $package.Include
        $packageVersion = $package.Version
        $packages += [PSCustomObject]@{ Name = $packageName; Version = $packageVersion }
    }

    # Display the packages and let the user select one
    $selectedPackage = $packages | Out-GridView -Title "Select a NuGet Package" -PassThru

    # Check if a package was selected
    if ($selectedPackage -eq $null) {
        Write-Host "No package selected."
    }

    # Output the selected package
    Write-Host "Selected Package: $($selectedPackage.Name), Version: $($selectedPackage.Version)"

    # List available versions for the selected package
    $packageName = $selectedPackage.Name
    $availableVersions = & nuget list $packageName -AllVersions -Source https://api.nuget.org/v3/index.json

    # Output the available versions
    #Write-Host "Available Versions for $packageName:"
    $availableVersions | ForEach-Object { Write-Host $_ }
}