. $PSScriptRoot\..\variables.ps1

#gitImport.ps1 as a function
function gitImport(){
    $path = "C:\Users\$username\source\repos"
    #$saveLocation = "C:\Users\$userName\OneDrive - NewDay Cards Ltd\Documents\_scripts"

    # Get all directories that do not start with an underscore
    $directories = Get-ChildItem -Path $path -Directory | Where-Object { $_.Name -notmatch '^_' }

    # Get today's date and format it
    $date = Get-Date -Format "yyyyMMddhhmmss"

    # Define the output file name with the specified save location
    $outputFile = Join-Path -Path $path -ChildPath "gitImport_$date.ps1"

    # Initialize an array to hold the git clone commands
    $commands = @("cd $path")

    # Generate the git clone commands
    foreach ($directory in $directories) {
        $configPath = Join-Path -Path $directory.FullName -ChildPath ".git\config"
        if (Test-Path -Path $configPath) {
            $configContent = Get-Content -Path $configPath
            $url = $configContent | Select-String -Pattern 'url = (.+)' | ForEach-Object { $_.Matches[0].Groups[1].Value }
            if ($url) {
                $command = "git clone $url"
                $commands += $command
            }
        }
    }

    # Write the commands to the output file
    $commands | Out-File -FilePath $outputFile -Encoding UTF8
}