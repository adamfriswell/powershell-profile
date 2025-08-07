. $PSScriptRoot\..\variables.ps1

<#
.SYNOPSIS
    Winget commands for new laptop setup
#>
function laptopSetup(){
    #productivity
    winget install -e --id Notion.Notion;
    winget install -e --id Keeper.KeeperDesktop;
    winget install -e --id Spotify.Spotify;
    winget install -e --id VideoLAN.VLC;

    #power user
    winget install Microsoft.Powershell;
    winget install -e --id Microsoft.PowerToys;
    winget install DevToys-app.DevToys;
    winget install -e --id WinMerge.WinMerge;

    #coding
    winget install -e --id Git.Git
    winget install -e --id GitHub.cli;

    winget install -e --id Postman.Postman;
    winget install -e --id GnuPG.Gpg4win;

    ##ms
    winget install -e --id Microsoft.VisualStudioCode;
    winget install -e --id Microsoft.NuGet;
    winget install -e --id Microsoft.Azd; #azd developer CLI
    winget install -e --id Microsoft.AzureCLI #az CLI
    winget install -e --id Microsoft.Azure.CosmosEmulator;

    winget install -e --id Oracle.JavaRuntimeEnvironment;
}

<#
.SYNOPSIS
    Displays installed command-line tools, grouped by category.
.DESCRIPTION
    This function finds all non-system CLI tools and displays them in categorized, sorted tables.
    By default, it hides uncategorized tools. Use the -ShowOther switch to include them in the output.

    It specifically favours the notepad.exe located in a Windows directory and ignores other versions.
#>
function tools ([switch]$ShowOther) {
    # 1. Define the custom display order and categories
    $customOrder = 'System', 'Dotnet', 'Git', 'Dev', 'Azure', 'JS', 'Other Langs', 'Windows', 'Other'
    $categories = @{
        # Azure ☁️
        'az' = 'Azure'; 'azd' = 'Azure'; 'func' = 'Azure'; 'swa' = 'Azure';
        # Windows 🖼️
        'explorer' = 'Windows'; 'mspaint' = 'Windows'; 'SnippingTool' = 'Windows'; "notepad" = 'Windows';
        # System ⚙️
        'winget' = 'System'; 'wsl' = 'System'; 'wt' = 'System';
        # Shells 🐚
        'bash' = 'Shells'; 'pwsh' = 'Shells'; 
        # Dev Tools 🛠️
        'code' = 'Dev'; 'gpg' = 'Dev'; 
        # Dotnet
        'dotnet' = 'Dotnet'; "nuget" = 'Dotnet';
        #Git
        'gh' = 'Git'; 'git' = 'Git'; "github" = 'Git';
        # Other Languages 🐍
        'java' = 'Other Langs'; 'python' = 'Other Langs'; 'python3' = 'Other Langs';
        # JavaScript 📜
        'node' = 'JS'; 'npm' = 'JS'; 'npx' = 'JS'; 'yarn' = 'JS'; "nvm" = 'JS';
    }

    # 2. Get, filter, categorize, group, and display the commands
    Get-Command -CommandType Application |
        # Group commands by their base name (e.g., 'notepad' for 'notepad.exe').
        # This allows us to handle cases with multiple versions of the same command.
        Group-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) } |
        # Process each group to select the desired version of each command.
        ForEach-Object {
            if ($_.Name -eq 'notepad') {
                # SPECIAL CASE: For 'notepad', we specifically want the version from the Windows directory.
                # We select the first one found to ensure uniqueness in the final list.
                $_.Group | Where-Object { $_.Source -like '*\Windows\*' } | Select-Object -First 1
            }
            else {
                # GENERAL CASE: For all other commands, filter out those from System32,
                # retaining the original script's intent of hiding default system utilities.
                $_.Group | Where-Object { $_.Source -notlike "*\Windows\System32\*" }
            }
        } |
        Select-Object Name, Source, @{
            Name = 'Category';
            Expression = {
                $baseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
                if ($categories.ContainsKey($baseName)) { $categories[$baseName] }
                else { 'Other' }
            }
        } |
        Group-Object -Property Category |
        # Conditionally show the 'Other' group based on the -ShowOther switch
        Where-Object { $ShowOther -or $_.Name -ne 'Other' } |
        # Sort groups based on the index in the custom order array
        Sort-Object { $customOrder.IndexOf($_.Name) } |
        ForEach-Object {
            # Print a formatted header for the category
            Write-Host "`n--- $($_.Name) ---" -ForegroundColor Cyan

            # Display the commands in that category in a table
            $_.Group | Sort-Object Name | Format-Table -Property Name, Source -AutoSize
        }
}