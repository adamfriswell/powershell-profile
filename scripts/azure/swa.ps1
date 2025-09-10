<#
.SYNOPSIS
    swa list app settings
#>
function getSwaAppSettings($resource, $resourceGroup){
    az staticwebapp appsettings list -n $resource -g $resourceGroup
}

### Start SWA ###

<#
.SYNOPSIS
    swa start alias
#>
function startSwa($reactPort = 3000, $apiPort = 7071){
    swa start http://localhost:$reactPort --api-location http://localhost:$apiPort
}

<#
.SYNOPSIS
    npx swa start alias hosted
.DESCRIPTION
    Passing `--api-location` is used when the swa cli runs the func app process for you
#>
function npxStartSwa($reactPort = 3000, $apiPort = 7071){
    npx @azure/static-web-apps-cli@2.0.1 start http://localhost:$reactPort --api-location http://localhost:$apiPort
}

<#
.SYNOPSIS
    npx swa start alias self-hosted
.DESCRIPTION
    Passing `--api-devserver-url` instead of `--api-location` is used when you run the func app locally in a sepearte process
#>
function npxSelfHostedStartSwa($reactPort = 3000, $apiPort = 7071){
    npx @azure/static-web-apps-cli@2.0.1 start http://localhost:$reactPort --api-devserver-url http://localhost:$apiPort
}