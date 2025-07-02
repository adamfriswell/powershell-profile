. $PSScriptRoot\scripts\variables.ps1

#Aliases for commonly used programs
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias vs-azurite "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator\azurite.exe"
Set-Alias ntn "C:\Users\$username\AppData\Local\Programs\Notion\Notion.exe"

# Load scripts selectively instead of recursively scanning all files
. "$repoPath\powershell-profile\scripts\util.ps1"
. "$repoPath\powershell-profile\scripts\git\generalGit.ps1"
. "$repoPath\powershell-profile\scripts\git\github.ps1"
. "$repoPath\powershell-profile\scripts\git\gitImport.ps1"
. "$repoPath\powershell-profile\scripts\azure\az.ps1"
. "$repoPath\powershell-profile\scripts\dotnet\dotnet.ps1"
. "$repoPath\powershell-profile\scripts\dotnet\nuget.ps1"
. "$repoPath\powershell-profile\scripts\dotnet\visualStudio.ps1"
. "$repoPath\powershell-profile\scripts\misc\claude.ps1"
. "$repoPath\powershell-profile\scripts\misc\laptopSetup.ps1"
. "$repoPath\powershell-profile\scripts\misc\meta.ps1"
. "$repoPath\powershell-profile\scripts\misc\newday.ps1"
. "$repoPath\powershell-profile\scripts\misc\zeti.ps1"

# Get-ChildItem -Path "$repoPath\powershell-profile\scripts" -Recurse -Filter "*.ps1" | ForEach-Object { . $_.FullName }
# newRepoAliases

Set-Alias os openSln
Set-Alias sr searchRepo
Set-Alias c cls

# unpin unwanted apps from taskbar that company policy enforces
#unpinAppVerbose Word
#unpinAppVerbose Outlook
#unpinAppVerbose Powerpoint
#unpinAppVerbose Excel
#unpinAppVerbose OneDrive
#unpinAppVerbose "Cisco AnyConnect Secure Mobility Client"
#unpinAppVerbose "Microsoft Edge"
#unpinApp "Google Chrome"

#oh-my-posh --init --shell pwsh | Invoke-Expression #--config "C:/Users/$username/oh-my-posh-config.json" | Invoke-Expression 