function CosmosDbNotStartingOnLocalHostFix(){
    #from https://stackoverflow.com/questions/62210493/azure-cosmos-db-emulator-not-running-it-starts-and-then-throws-error/62236663#62236663
    lodctr /R
    c:\Windows\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe -i
    lodctr /R
}

function azToken($pillar, $env){
    $scope = "api://ndt-$pillar-$env/.default"
    AZ account get-access-token --scope $scope
}