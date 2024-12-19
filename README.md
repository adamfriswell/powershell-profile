# A collection of Powershell scripts

> [!WARNING]
> I assume you store all your repos under one folder at $repoPath in variables.ps1

Please feel free to clone this repo and uses these scripts.

## Instructions:
1. Clone
2. Updated the variables in "...powershell-profile\scripts\variables.ps1"
3. For any Powershell profile (eg. Powershell or Windows Powershell), you can now share these scripts by using the following line in the relevant profile

> [!NOTE]
> Find your profile `.ps1` file by opening up a shell in the selected profile and typing `code $profile` to open in VS Code
```
. "C:\Users\YOUR_USERNAME\source\repos\powershell-profile\Microsoft.PowerShell_profile.ps1"
```

4. You might have to set your shells execution policy `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine`
