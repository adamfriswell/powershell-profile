. $PSScriptRoot\scripts\variables.ps1

#Aliases for commonly used programs
Set-Alias vs "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
Set-Alias ntn "C:\Users\$username\AppData\Local\Programs\Notion\Notion.exe"

Get-ChildItem -Path "$repoPath\powershell-profile\scripts" -Recurse -Filter "*.ps1" | ForEach-Object { . $_.FullName }
newRepoAliases
Set-Alias vss openSln

#unpin unwanted apps from taskbar that company policy enforces
unpinAppVerbose Word
# unpinAppVerbose Outlook
unpinAppVerbose Powerpoint
unpinAppVerbose Excel
unpinAppVerbose OneDrive
unpinAppVerbose "Cisco AnyConnect Secure Mobility Client"
unpinAppVerbose "Microsoft Edge"
#unpinApp "Google Chrome"

#oh-my-posh --init --shell pwsh | Invoke-Expression #--config "C:/Users/$username/oh-my-posh-config.json" | Invoke-Expression 