# A collection of Powershell scripts

> [!WARNING]
> I assume you store all your repos under one folder at `$repoPath` in `variables.ps1`

Please feel free to clone this repo and uses these scripts.

## Instructions:
1. Clone
2. Updated the variables in `scripts\variables.ps1`
3. To use the scripts defined in this repo, you can reference them in any Powershell profile (eg. Powershell or Windows Powershell), by adding the following line into the relevant profile
```
. "C:\Users\YOUR_USERNAME\source\repos\powershell-profile\Microsoft.PowerShell_profile.ps1"
```
4. You might have to set your shells execution policy `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine`
5. These scripts use vanilla Powershell along with the following CLI tools as a dependancy for some functions:
    * [Git](https://git-scm.com/)
    * [dotnet SDK](https://dotnet.microsoft.com/en-us/download)
    * [dotnet-outdated tool](https://github.com/dotnet-outdated/dotnet-outdated)
    * Requires auth with account:
        * [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
        * [GitHub CLI](https://cli.github.com/)


> [!NOTE]
> Find your profile `.ps1` file by opening up a shell in the selected profile and typing `code $profile` to open in VS Code

# Windows Terminal settings
* Colour schemes = One Half Dark
* Profiles > Defaults:
    * Starting Directory = `C://Users/<YOUR_USERNAME>/source/repos`
    * Apperance > Transparency = 98%
