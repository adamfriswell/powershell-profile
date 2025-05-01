. $PSScriptRoot\..\variables.ps1

#gmp = git main pull
function gmp($branch){
    git checkout main
    git pull
    if($branch){
        git checkout -b $branch
    }
}

#gmm = git main merge
function gmm(){
    #$branch = git rev-parse --abbrev-ref HEAD
    git checkout main
    git pull
    git checkout - #$branch
    git merge main
    # git add .
    # git push
}

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

function vibes(){
    git status
}

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
}

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

function gpgAgentFix(){
    gpg-connect-agent
}

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