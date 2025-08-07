<#
.SYNOPSIS
    Get Azure access token for a pillar/env
#>
function azToken($pillar, $env){
    $scope = "api://ndt-$pillar-$env/.default"
    AZ account get-access-token --scope $scope
}