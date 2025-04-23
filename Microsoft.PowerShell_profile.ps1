. $PSScriptRoot\scripts\variables.ps1

#Aliases for commonly used programs
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias notion "C:\Users\$username\AppData\Local\Programs\Notion\Notion.exe"

Get-ChildItem -Path "$repoPath\powershell-profile\scripts" -Recurse -Filter "*.ps1" | ForEach-Object { . $_.FullName }
New-RepoAliases

#unpin unwanted apps from taskbar that company policy enforces
UnpinAppVerbose Word
# UnpinAppVerbose Outlook
UnpinAppVerbose Powerpoint
UnpinAppVerbose Excel
UnpinAppVerbose OneDrive
UnpinAppVerbose "Cisco AnyConnect Secure Mobility Client"
UnpinAppVerbose "Microsoft Edge"
#UnpinApp "Google Chrome"

#oh-my-posh --init --shell pwsh | Invoke-Expression #--config "C:/Users/$username/oh-my-posh-config.json" | Invoke-Expression 