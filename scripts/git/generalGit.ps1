. $PSScriptRoot\..\variables.ps1

<#
.SYNOPSIS
    Git: pull main, opt checkout branch
.DESCRIPTION
    gmp stands for "git main pull". 
#>
function gmp($branch){
    git checkout main
    git pull
    if($branch){
        git checkout -b $branch
    }
}

<#
.SYNOPSIS
    Git: merge main into current branch
.DESCRIPTION
    gmm stands for "git main merge". 
#>
function gmm(){
    #$branch = git rev-parse --abbrev-ref HEAD
    git checkout main
    git pull
    git checkout - #$branch
    git merge main
    # git add .
    # git push
}

<#
.SYNOPSIS
    Git: checkout last branch
#>
function lastBranch(){
    git checkout -
}

<#
.SYNOPSIS
    Git: stage, commit and push changes
#>
function yeet($m){
    Write-Host "Yeeting commit..." -ForegroundColor Cyan
    git add .
    if($m){
        git commit -m $m
    }
    else{
        git commit -m "."
    }
    git push
}

<#
.SYNOPSIS
    Git: status alias
#>
function vibes(){
    git status
}

<#
.SYNOPSIS
    Git: status alias, for all repos
#>
function recursiveVibes(){
    # Get all subdirectories in the root directory
    $repoDirs = Get-ChildItem -Path $repoPath -Directory

    # Iterate through each directory
    foreach ($repoDir in $repoDirs) {
        # Change to the repository directory
        Set-Location -Path $repoDir.FullName
        
        # Get the list of stashes in the repository
        Write-Host "Git status for $($repoDir.FullName):"
        vibes
        Write-Host "------------------------------"
    }

    Set-Location -Path $repoPath
}

<#
.SYNOPSIS
    Git: find any stashes in all repos
#>
function gitStashes(){
    # Get all subdirectories in the root directory
    $repoDirs = Get-ChildItem -Path $repoPath -Directory

    # Iterate through each directory
    foreach ($repoDir in $repoDirs) {
        # Change to the repository directory
        Set-Location -Path $repoDir.FullName
        
        # Get the list of stashes in the repository
        $stashes = git stash list
        
        # If there are stashes, display them
        if ($stashes) {
            Write-Host "Stashes found in $($repoDir.FullName):"
            $stashes
        } else {
            Write-Host "No stashes found in $($repoDir.FullName)."
        }
    }

    Set-Location -Path $repoPath
}

<#
.SYNOPSIS
    Git: Pull latest changes for all repos
#>
function updateAllRepos(){
    # Get all subdirectories in the root directory
    $repoDirs = Get-ChildItem -Path $repoPath -Directory

    # Iterate through each directory
    foreach ($repoDir in $repoDirs) {
        Set-Location -Path $repoDir.FullName
        Write-Host "Updating $($repoDir.FullName):"
        gmp
        Write-Host "------------------------------"
    }
}

<#
.SYNOPSIS
    Git: Clone and open a repo
#>
function gitCloneAndOpen($gitRepoUrl){

    $repoName = $gitRepoUrl -replace '.*\/([^\/]+?)(\.git)?$', '$1'

    Set-Location -Path $repoPath

    if (Test-Path -Path $repoName) {
        Write-Host "WARNING: Directory '$repoName' already exists!" -ForegroundColor Yellow
    }

    git clone $gitRepoUrl

    # Check if clone was successful
    if ($LASTEXITCODE -eq 0) {
        Set-Location -Path $repoName
        vss
    }
}