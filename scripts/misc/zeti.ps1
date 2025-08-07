. $PSScriptRoot\..\azure\swa.ps1

$billingServicePath = "C:\Users\adamf\source\repos\BillingService"

function zetiBranch($ticketNumber){
    gmp -branch "feature/af/zhs-$ticketNumber"
}

### Aliases ###
Set-Item -Path function:global:"bs" -Value "cd $billingServicePath"
Set-Item -Path function:global:"zvs" -Value "cd C:\Users\adamf\source\repos\VehicleService"

Set-Item -Path function:global:"invswa" -Value "cd $billingServicePath\InvestorDashboard.Swa"
Set-Item -Path function:global:"invapi" -Value "cd $billingServicePath\InvestorDashboard.Swa\InvestorDashboard.Api"

Set-Item -Path function:global:"oppswa" -Value "cd $billingServicePath\AssetOperatorPortal"
Set-Item -Path function:global:"oppapi" -Value "cd $billingServicePath\AssetOperatorPortal\AssetOperatorPortal.Api"

Set-Item -Path function:global:"manswa" -Value "cd $billingServicePath\BillingService.Swa"
Set-Item -Path function:global:"manapi" -Value "cd $billingServicePath\BillingService.Swa\BillingService.Swa.Api"

Set-Item -Path function:global:"bfn" -Value "cd $billingServicePath\BillingService.Function"
Set-Item -Path function:global:"hds" -Value "cd $billingServicePath\HydrogenDispenserService.Function"
Set-Item -Path function:global:"css" -Value "cd $billingServicePath\ChargingStationService.Function"

#---------------------------------------------------------------------------------------------------------------------#

### Serve API content ###
<#
.SYNOPSIS
    invest yarn start alias
#>
function serveInvContent(){
    invswa
    yarn start
}

<#
.SYNOPSIS
    opearte yarn start alias
#>
function serveOppContent(){
    oppswa
    yarn start
}

<#
.SYNOPSIS
    manage yarn start alias
#>
function serveManContent(){
    manswa
    yarn start
}

#---------------------------------------------------------------------------------------------------------------------#

### Start API ###
<#
.SYNOPSIS
    invest func start alias
#>
function startInvApi(){
    invapi
    func start
}

<#
.SYNOPSIS
    operate func start alias
#>
function startOppApi(){
    oppapi
    func start
}

<#
.SYNOPSIS
    manage func start alias
#>
function startManApi(){
    manapi
    func start
}

#---------------------------------------------------------------------------------------------------------------------#

### Start SWA ###
<#
.SYNOPSIS
    invest swa start alias
#>
function startInvSwa(){
    invswa
    startSwa
}

<#
.SYNOPSIS
    opearte swa start alias
#>
function startOppSwa(){
    oppswa
    startSwa
}

<#
.SYNOPSIS
    manage swa start alias
#>
function startManSwa(){
    manswa
    startSwa -reactPort 5173
}

#---------------------------------------------------------------------------------------------------------------------#

### Start SWA with npx ###

<#
.SYNOPSIS
    invest npx swa start alias
#>
function npxStartInvSwa(){
    invswa
    npxStartSwa
}

<#
.SYNOPSIS
    operate npx swa start alias
#>
function npxStartOppSwa(){
    oppswa
    npxStartSwa
}

<#
.SYNOPSIS
    manage npx swa start alias
#>
function npxStartManSwa(){
    manswa
    npxStartSwa -reactPort 5173
}

#---------------------------------------------------------------------------------------------------------------------#

### Start SWA with npx ###
<#
.SYNOPSIS
    invest npx self hosted swa start alias
#>
function npxSelfStartInvSwa(){
    invswa
    npxSelfHostedStartSwa
}

<#
.SYNOPSIS
    operate npx swa start alias
#>
function npxSelfStartOppSwa(){
    oppswa
    npxSelfHostedStartSwa
}

<#
.SYNOPSIS
    manage npx swa start alias
#>
function npxSelfStartManSwa(){
    manswa
    npxSelfHostedStartSwa -reactPort 5173
}

#---------------------------------------------------------------------------------------------------------------------#

### Start each portal ###

#serve content, start API, start SWA
#currently not using above aliases as powershell profile won't load when starting new Windows Teminal tab

<#
.SYNOPSIS
    start manage portal: serve content, start API, start SWA
#>
function startManage(){
    startPortal "BillingService.Swa" "BillingService.Swa.Api" 5173
}

<#
.SYNOPSIS
    start invest portal: serve content, start API, start SWA
#>
function startInvest(){
    startPortal "InvestorDashboard.Swa" "InvestorDashboard.Api"
}

<#
.SYNOPSIS
    start operate portal: serve content, start API, start SWA
#>
function startOperate(){
    startPortal "AssetOperatorPortal" "AssetOperatorPortal.Api"
}

<#
.SYNOPSIS
    start a portal: serve content, start API, start SWA
#>
function startPortal($swaPath, $apiPath, $reactPort = 3000, $apiPort = 7071, $swaPort = 4280){
    wt -w 0 new-tab --title "Serve Content" -d "C:\Users\adamf\source\repos\BillingService\$swaPath" pwsh -c "yarn start"
    wt -w 0 new-tab --title "API" -d "C:\Users\adamf\source\repos\BillingService\$swaPath\$apiPath" pwsh -c "func start"
    wt -w 0 new-tab --title "SWA" -d "C:\Users\adamf\source\repos\BillingService\$swaPath" pwsh -c "npx @azure/static-web-apps-cli@2.0.1 start http://localhost:$reactPort --api-devserver-url http://localhost:$apiPort"
    
    Start-Process chrome "http://localhost:$reactPort"
    Start-Process chrome "http://localhost:$apiPort"
    Start-Process chrome "http://localhost:$swaPort"
}

#---------------------------------------------------------------------------------------------------------------------#

### Scratchpad ###

# dotnet test BillingService.IntegrationTests/BillingService.IntegrationTests.csproj

# az appservice plan show --ids $(az functionapp show --name funcbillingservicecint -g rgbillingservicecint --query serverFarmId -o tsv) --query sku
# az functionapp show --name funcbillingservicecint --resource-group rgbillingservicecint --query "{serverFarmId: serverFarmId, state: state}"


#---------------------------------------------------------------------------------------------------------------------#