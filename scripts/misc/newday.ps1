. $PSScriptRoot\..\variables.ps1

<#
.SYNOPSIS
    Prints a table of all CL tenantIds
#>
function tenantIds($tenantCode, $tenantId) {
    # Hardcoded directory path
    $path = "$repoPath\NewDay.ClosedLoop.Core.Infra\src\NewDay.ClosedLoop.Core.Configuration\configuration\ndt"

    # Ensure the directory exists
    if (-not (Test-Path -Path $path -PathType Container)) {
        Write-Error "Directory does not exist: $path"
        exit 1
    }

    # GUID regex pattern
    $guidPattern = "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"

    # Initialize results array
    $results = @()

    # Get all JSON files that match the GUID pattern - recursively searching child folders
    Get-ChildItem -Path $path -Filter "*.json" -Recurse | Where-Object { 
        $_.Name -match "^$guidPattern\.json$" 
    } | ForEach-Object {
        $guid = $_.BaseName
        $filePath = $_.FullName
        
        try {
            # Read and parse the JSON content
            $jsonContent = Get-Content -Path $filePath -Raw | ConvertFrom-Json
            
            # Extract tenantCode if it exists
            $tenantCode = if ($jsonContent.PSObject.Properties.Name -contains "tenantCode") {
                $jsonContent.tenantCode
            } else {
                "N/A"
            }
            
            # Extract environment info from parent folder structure
            $tenantsParentFolder = (Get-Item (Split-Path -Parent (Split-Path -Parent $filePath))).Name
            
            # Add to results
            $results += [PSCustomObject]@{
                TenantId = $guid
                TenantCode = $tenantCode
                Environment = $tenantsParentFolder
            }
        }
        catch {
            Write-Warning "Error processing file $($_.Name): $_"
        }
    }

    # Display results as a table
    if ($results.Count -gt 0) {
        # Define environment order
        $envOrder = @{
            "dev" = 1
            "stg" = 2
            "prd" = 3
        }
        
        # Sort results by environment (using predefined order), then by tenant code
        $sortedResults = $results | Sort-Object -Property @{
            Expression = { $envOrder[$_.Environment.ToLower()] }
        }, TenantCode
        
        # Create a new collection for the final output with separators
        $tableOutput = @()
        $currentEnv = $null
        $firstEnv = $true
        
        foreach ($item in $sortedResults) {
            # If this is a new environment but not the first one, add a separator row
            if ($item.Environment -ne $currentEnv) {
                if (!$firstEnv) {
                    # Add a continuous line separator row with specific lengths
                    $tableOutput += [PSCustomObject]@{
                        Environment = "-----------"
                        TenantCode = "----------"
                        TenantId = "------------------------------------"
                    }
                } else {
                    $firstEnv = $false
                }
                $currentEnv = $item.Environment
            }
            
            # Add the actual data row
            $tableOutput += [PSCustomObject]@{
                Environment = $item.Environment
                TenantCode = $item.TenantCode
                TenantId = $item.TenantId
            }
        }
        
        # Display as a single table
        $tableOutput | Format-Table -Property Environment, TenantCode, TenantId -AutoSize
    } else {
        Write-Host "No matching JSON files found in $path or its subfolders"
    }
}