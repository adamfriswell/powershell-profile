$username = "YOUR_USERNAME"

#Aliases for commonly used programs
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias notion "C:\Users\$username\AppData\Local\Programs\Notion\Notion.exe"

#--------- Import functions from other scripts ---------
. "C:\Users\$username\source\repos\powershell-profile\scripts\util.ps1"
. "C:\Users\$username\source\repos\powershell-profile\scripts\azure\cosmos.ps1"
. "C:\Users\$username\source\repos\powershell-profile\scripts\dotnet\dotnet.ps1"

#Git
. "C:\Users\$username\source\repos\powershell-profile\scripts\git\generalGit.ps1"
. "C:\Users\$username\source\repos\powershell-profile\scripts\git\repoAliases.ps1"
. "C:\Users\$username\source\repos\powershell-profile\scripts\git\fn_gitImport.ps1"
#------------------------------------------------------

New-RepoAliases

# #unpin unwanted apps from taskbar that company policy enforces
UnpinApp Word
UnpinApp Outlook
UnpinApp Powerpoint
UnpinApp Excel
UnpinApp OneDrive
UnpinApp "Cisco AnyConnect Secure Mobility Client"
UnpinApp "Microsoft Edge"
UnpinApp "Google Chrome"

# #oh-my-posh --init --shell pwsh | Invoke-Expression #--config "C:/Users/$username/oh-my-posh-config.json" | Invoke-Expression 