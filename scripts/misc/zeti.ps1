. $PSScriptRoot\..\azure\swa.ps1

$billingServicePath = "C:\Users\adamf\source\repos\BillingService"

function zetiBranch($ticketNumber){
    gmp -branch "feature/af/zhs-$ticketNumber"
}

### Aliases ###
Set-Item -Path function:global:"bs" -Value "cd $billingServicePath"
Set-Item -Path function:global:"zvs" -Value "cd C:\Users\adamf\source\repos\VehicleService"

Set-Item -Path function:global:"invest.cdSwa" -Value "cd $billingServicePath\InvestorDashboard.Swa"
Set-Item -Path function:global:"invest.cdApi" -Value "cd $billingServicePath\InvestorDashboard.Swa\InvestorDashboard.Api"

Set-Item -Path function:global:"operate.cdSwa" -Value "cd $billingServicePath\AssetOperatorPortal"
Set-Item -Path function:global:"operate.cdApi" -Value "cd $billingServicePath\AssetOperatorPortal\AssetOperatorPortal.Api"

Set-Item -Path function:global:"manage.cdSwa" -Value "cd $billingServicePath\BillingService.Swa"
Set-Item -Path function:global:"manage.cdApi" -Value "cd $billingServicePath\BillingService.Swa\BillingService.Swa.Api"

Set-Item -Path function:global:"hub.cdSwa" -Value "cd $billingServicePath\Zeti.Hub.Swa"
Set-Item -Path function:global:"hub.cdApi" -Value "cd $billingServicePath\Zeti.Hub.Swa\Zeti.Hub.Swa.Api"

Set-Item -Path function:global:"bfn" -Value "cd $billingServicePath\BillingService.Function"
Set-Item -Path function:global:"hds" -Value "cd $billingServicePath\HydrogenDispenserService.Function"
Set-Item -Path function:global:"css" -Value "cd $billingServicePath\ChargingStationService.Function"
Set-Item -Path function:global:"pcomp" -Value "cd $billingServicePath\Portals.Components"

#---------------------------------------------------------------------------------------------------------------------#

### Serve API content ###
<#
.SYNOPSIS
    invest yarn start alias
#>
function invest.serve(){
    invest.cdSwa
    yarn start
}

<#
.SYNOPSIS
    opearte yarn start alias
#>
function operate.serve(){
    operate.cdSwa
    yarn start
}

<#
.SYNOPSIS
    manage yarn start alias
#>
function manage.serve(){
    manage.cdSwa
    yarn start
}

<#
.SYNOPSIS
    hub yarn start alias
#>
function hub.serve(){
    hub.cdSwa
    yarn start
}

#---------------------------------------------------------------------------------------------------------------------#

### Start API ###
<#
.SYNOPSIS
    invest func start alias
#>
function invest.func(){
    invest.cdApi
    func start
}

<#
.SYNOPSIS
    operate func start alias
#>
function operate.func(){
    operate.cdApi
    func start
}

<#
.SYNOPSIS
    manage func start alias
#>
function manage.func(){
    manage.cdApi
    func start
}
#

<#
.SYNOPSIS
    hub func start alias
#>
function hub.func(){
    hub.cdApi
    func start
}

#---------------------------------------------------------------------------------------------------------------------#

### Start SWA ###
<#
.SYNOPSIS
    invest swa start alias
#>
function invest.start(){
    invest.cdSwa
    startSwa
}

<#
.SYNOPSIS
    opearte swa start alias
#>
function operate.start(){
    operate.cdSwa
    startSwa
}

<#
.SYNOPSIS
    manage swa start alias
#>
function manage.start(){
    manage.cdSwa
    startSwa -reactPort 5173
}

<#
.SYNOPSIS
    hub swa start alias
#>
function hub.start(){
    hub.cdSwa
    startSwa
}

#---------------------------------------------------------------------------------------------------------------------#

### Start SWA with npx ###

<#
.SYNOPSIS
    invest npx swa start alias
#>
function invest.startNpx(){
    invest.cdSwa
    npxStartSwa
}

<#
.SYNOPSIS
    operate npx swa start alias
#>
function operate.startNpx(){
    operate.cdSwa
    npxStartSwa
}

<#
.SYNOPSIS
    manage npx swa start alias
#>
function manage.startNpx(){
    manage.cdSwa
    npxStartSwa -reactPort 5173
}

<#
.SYNOPSIS
    hub swa start alias
#>
function hub.start(){
    hub.cdSwa
    startSwa
}

#---------------------------------------------------------------------------------------------------------------------#

### Start SWA with npx ###
<#
.SYNOPSIS
    invest npx self hosted swa start alias
#>
function invest.startNpxSelf(){
    invest.cdSwa
    npxSelfHostedStartSwa
}

<#
.SYNOPSIS
    operate npx swa start alias
#>
function operate.startNpxSelf(){
    operate.cdSwa
    npxSelfHostedStartSwa
}

<#
.SYNOPSIS
    manage npx swa start alias
#>
function manage.startNpxSelf(){
    manage.cdSwa
    npxSelfHostedStartSwa -reactPort 5173
}

<#
.SYNOPSIS
    hub npx swa start alias
#>
function hub.startNpxSelf(){
    hub.cdSwa
    npxSelfHostedStartSwa
}

#---------------------------------------------------------------------------------------------------------------------#

### Start each portal ###

#serve content, start API, start SWA
#currently not using above aliases as powershell profile won't load when starting new Windows Teminal tab

<#
.SYNOPSIS
    start invest portal: serve content, start API, start SWA
#>
function invest.startAll(){
    startPortal "InvestorDashboard.Swa" "InvestorDashboard.Api"
}

<#
.SYNOPSIS
    start operate portal: serve content, start API, start SWA
#>
function operate.startAll(){
    startPortal "AssetOperatorPortal" "AssetOperatorPortal.Api"
}

<#
.SYNOPSIS
    start manage portal: serve content, start API, start SWA
#>
function manage.startAll(){
    startPortal "BillingService.Swa" "BillingService.Swa.Api" 5173
}

<#
.SYNOPSIS
    start hub portal: serve content, start API, start SWA
#>
function hub.startAll(){
    startPortal "Zeti.Hub.Swa" "Zeti.Hub.Swa.Api"
}

<#
.SYNOPSIS
    start a portal: serve content, start API, start SWA
#>
function startPortal($swaPath, $apiPath, $reactPort = 3000, $apiPort = 7071, $swaPort = 4280){
    wt -w 0 new-tab --title "Serve Content" -d "C:\Users\adamf\source\repos\BillingService\$swaPath" pwsh -c "yarn start"
    Start-Sleep -Milliseconds 500
    
    wt -w 0 new-tab --title "API" -d "C:\Users\adamf\source\repos\BillingService\$swaPath\$apiPath" pwsh -c "func start"
    Start-Sleep -Milliseconds 500
    
    wt -w 0 new-tab --title "SWA" -d "C:\Users\adamf\source\repos\BillingService\$swaPath" pwsh -c "swa start http://localhost:$reactPort --api-devserver-url http://localhost:$apiPort"
    
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