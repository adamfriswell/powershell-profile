. $PSScriptRoot\..\variables.ps1
$debug = $false

function SetAliasIfExists($name, $value){
    if($debug){
        $output = "$name = $value"
        $output = $output -replace "`n", "" -replace "`r", ""
        Write-Output $output
    }

    if (!(Get-Alias -Name $name -ErrorAction SilentlyContinue)) {
        $scriptBlock = [scriptblock]::Create($value)
        Set-Item -Path function:global:$name -Value $scriptBlock
    } else {
        Write-Warning "Alias $name already exists."
    }
}

function New-RepoAliases {
    $dirs = Get-ChildItem -Path "." -Directory | Where-Object { $_.Name -like "NewDay*" }
    $folders = Get-ChildItem -Path "." -Directory -Recurse | Where-Object { $_.Name -like "*-" }
    foreach($folder in $folders){
        $folderDirs = Get-ChildItem -Path $folder.Name -Directory | Where-Object { $_.Name -like "NewDay*" }
        $dirs += $folderDirs
    }

    foreach ($dir in $dirs) {
        $parts = $dir.Name.Split('.')
        $aliasName = ""
        for ($i = $parts.Length - 1; $i -ge 0; $i--) {
            if ($parts[$i] -eq "NewDay" -or ($i -eq 1 -and ($parts[$i] -eq "ClosedLoop" -or $parts[$i] -eq "Stratus"))) {
                continue
            }
            if ($i -eq 1 -and $parts[$i] -eq "Example") {
                $aliasPart = "ex-"
            } else {
                if ($parts[$i] -eq "EgressService") {
                    $aliasPart = "egrs"
                } elseif ($parts[$i] -eq "IngressService") {
                    $aliasPart = "igrs"
                } else {
                    $aliasPart = [string]::Join("", ([char[]]($parts[$i]) | Where-Object { $_ -cmatch "[A-Z]" })).ToLower()
                    if ($parts[$i] -eq "MultiTenancy" -or $parts[$i] -eq "RegularPayments") {
                        $aliasPart += "-"
                    }
                    if ($aliasPart.Length -eq 1 -and $parts[$i] -notin @("Core", "Platform", "Egress", "Ingress", "Fiserv", "Content", "Infra", "Spike", "Perimeter", "Docs", "Service", "Api", "Common", "Templates")) {
                        $aliasPart = $parts[$i].Substring(0, [Math]::Min(3, $parts[$i].Length)).ToLower()
                    }
                    if ($i -eq 1 -and ($parts[$i] -eq "AccountManagement" -or $parts[$i] -eq "TenancyManagement")) {
                        $aliasPart += "s-"
                    }
                    if ($parts[$i] -eq "HubSpoke") {
                        $aliasPart = "-" + $aliasPart
                    }
                }
            }
            $aliasName = $aliasPart + $aliasName
        }

        $repoAliasName = "r-" + $aliasName
        $directoryAliasName = "d-" + $aliasName

        $slnFile = Get-ChildItem -Path $dir.FullName -Filter "*.sln" -Recurse | Select-Object -First 1
        $repoAliasValue = if ($slnFile) { "cd $($slnFile.DirectoryName); Invoke-Item $($slnFile.FullName)" } else { "cd $($dir.FullName); code ." }

        SetAliasIfExists $repoAliasName $repoAliasValue
        SetAliasIfExists $directoryAliasName "cd $($dir.FullName)"
    }
}

function SearchRepo($SearchTerm) {
    $results = Get-ChildItem -Path $repoPath -Filter "*$SearchTerm*" -Directory -ErrorAction SilentlyContinue

    if ($results.Count -eq 0) {
        Write-Host "No folders found matching '$SearchTerm'" -ForegroundColor Yellow
        return
    }

    if ($results.Count -eq 1) {
        Set-Location $results
        return
    }

    Write-Host "Found $($results.Count) folders matching '$SearchTerm':" -ForegroundColor Cyan
    
    for ($i = 0; $i -lt $results.Count; $i++) {
        $folderName = Split-Path -Path $results[$i] -Leaf
        Write-Host "[$i] $folderName" -ForegroundColor Green
    }
    
    $selection = Read-Host "Enter number to navigate to (or 'c' to cancel)"
    if ($selection -eq "c") {
        return
    }
    
    $index = [int]$selection
    if ($index -ge 0 -and $index -lt $results.Count) {
        Set-Location $repoPath
        Set-Location $results[$index]
        vss .
    } else {
        Write-Host "Invalid selection" -ForegroundColor Red
    }
}

function GetCodeOwners {
    # Specifically target repos in the NewDayStratus organization
    $repos = gh repo list NewDayStratus --limit 100 --json nameWithOwner | ConvertFrom-Json
    
    $results = @()
    foreach ($repoObj in $repos) {
        $repo = $repoObj.nameWithOwner
        
        # Try to get CODEOWNERS from .github directory
        $codeownersGithub = $null
        try {
            $content = gh api repos/$repo/contents/.github/CODEOWNERS --jq '.content' 2>$null
            if ($content) {
                $codeownersGithub = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($content))
            }
        } catch {
            # Silently continue if there's an error
        }
        
        # If not found, try root directory
        $codeownersRoot = $null
        if (-not $codeownersGithub) {
            try {
                $content = gh api repos/$repo/contents/CODEOWNERS --jq '.content' 2>$null
                if ($content) {
                    $codeownersRoot = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($content))
                }
            } catch {
                # Silently continue if there's an error
            }
        }
        
        # Use whichever CODEOWNERS file was found
        $codeowners = if ($codeownersGithub) { $codeownersGithub } else { $codeownersRoot }
        
        # Extract @codeowners from the file content
        $codeownersMatch = if ($codeowners) {
            $matches = [regex]::Matches($codeowners, '@[\w-]+(?:/[\w-]+)?')
            if ($matches.Count -gt 0) {
                ($matches | ForEach-Object { $_.Value }) -join ', '
            } else {
                "No @codeowners found in file"
            }
        } else {
            "No CODEOWNERS file found"
        }
        
        $results += [PSCustomObject]@{
            Repository = $repo
            CodeOwners = $codeownersMatch
        }
    }
    
    $results | Format-Table -AutoSize
}

function GetGitConfigUrlOwner {
    $counter = 1
    Get-ChildItem -Path . -Recurse -Directory -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -eq ".git" } |
        ForEach-Object { 
            $configPath = Join-Path -Path $_.FullName -ChildPath "config"
            if (Test-Path $configPath) {
                $content = Get-Content -Path $configPath -Raw
                if ($content -match 'url\s*=\s*(?:https?://github\.com/|git@github\.com:)([^/]+)/([^/\s\.]+)') {
                    [PSCustomObject]@{
                        RepoPath = $_.FullName
                        Owner = $matches[1]
                    }
                }
            }
        } |
        Sort-Object -Property Owner, RepoPath |
        ForEach-Object { 
            $_ | Add-Member -MemberType NoteProperty -Name "Index" -Value $counter -PassThru
            $counter++
        } |
        Format-Table -Property Index, Owner, RepoPath -AutoSize
}