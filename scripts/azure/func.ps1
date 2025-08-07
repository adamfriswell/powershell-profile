<#
.SYNOPSIS
    func start alias
#>
function startFn(){
    func start
}

<#
.SYNOPSIS
    Fetch Azure Functions app settings and set as local.settings.json
#>
function getFuncAppSettings($fnApp){
    func azure functionapp fetch-app-settings $fnApp
}

<#
.SYNOPSIS
    Hit an Azure Functions endpoint
#>
function hitFunctionEndpoint($endpoint) {
    curl -Method POST -Uri "http://localhost:7071/api/$endpoint"
}

<#
.SYNOPSIS
    Hit an Azure Functions timer trigger endpoint
#>
function hitTimerTriggerFunctionEndpoint($endpoint) {
    curl -Method POST -Uri http://localhost:7071/admin/functions/$endpoint -Headers @{"Content-Type"="application/json"} -Body "{}"
}