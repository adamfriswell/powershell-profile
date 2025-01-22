. $PSScriptRoot\..\variables.ps1

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
    winget install -e --id Microsoft.Azd;
    winget install -e --id Microsoft.Azure.CosmosEmulator;

    winget install -e --id Oracle.JavaRuntimeEnvironment;
}