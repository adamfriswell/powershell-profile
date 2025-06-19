<#
.SYNOPSIS
    Hacky stackover fix for Cosmos Emulator not starting on localhost
#>
function cosmosDbNotStartingOnLocalHostFix(){
    #from https://stackoverflow.com/questions/62210493/azure-cosmos-db-emulator-not-running-it-starts-and-then-throws-error/62236663#62236663
    lodctr /R
    c:\Windows\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe -i
    lodctr /R
}

<#
.SYNOPSIS
    Get Azure access token for a pillar/env
#>
function azToken($pillar, $env){
    $scope = "api://ndt-$pillar-$env/.default"
    AZ account get-access-token --scope $scope
}