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