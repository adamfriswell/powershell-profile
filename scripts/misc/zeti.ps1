$billingServicePath = "C:\Users\adamf\source\repos\BillingService"

Set-Item -Path function:global:"bs" -Value "cd $billingServicePath"
Set-Item -Path function:global:"zvs" -Value "cd C:\Users\adamf\source\repos\VehicleService"

#Aliases for cd to paths
$invswa = [scriptblock]::Create("cd $billingServicePath\InvestorDashboard.Swa")
Set-Item -Path function:global:"invswa" -Value $invswa

$invapi = [scriptblock]::Create("cd $billingServicePath\InvestorDashboard.Swa\InvestorDashboard.Api")
Set-Item -Path function:global:"invapi" -Value $invapi

$oppswa = [scriptblock]::Create("cd $billingServicePath\AssetOperatorPortal")
Set-Item -Path function:global:"oppswa" -Value $oppswa

$oppapi = [scriptblock]::Create("cd $billingServicePath\AssetOperatorPortal\AssetOperatorPortal.Api")
Set-Item -Path function:global:"oppapi" -Value $oppapi

$manswa = [scriptblock]::Create("cd $billingServicePath\BillingService.Swa")
Set-Item -Path function:global:"manswa" -Value $manswa

$manapi = [scriptblock]::Create("cd $billingServicePath\BillingService.Swa\BillingService.Swa.Api")
Set-Item -Path function:global:"manapi" -Value $manapi

#Serve API content
function serveContent(){
    yarn start
}

function serveInvContent(){
    invswa
    serveContent
}

function serveOppContent(){
    oppswa
    serveContent
}

function serveManContent(){
    manswa
    serveContent
}

#Start API
function startApi(){
    func start
}

function startInvApi(){
    invapi
    startApi
}

function startOppApi(){
    oppapi
    startApi
}

function startManApi(){
    manapi
    startApi
}

#Start SWA
function startSwa($reactPort = 3000, $apiPort = 7071){
    swa start http://localhost:$reactPort --api-location http://localhost:$apiPort
}

function npxStartSwa($reactPort = 3000, $apiPort = 7071){
    npx @azure/static-web-apps-cli@2.0.1 start http://localhost:$reactPort --api-location http://localhost:$apiPort
}

function startInvSwa(){
    invswa
    startSwa
}

function startOppSwa(){
    oppswa
    startSwa
}

function startManSwa(){
    manswa
    startSwa -reactPort 5173
}

function npxStartInvSwa(){
    invswa
    npxStartSwa
}

function npxStartOppSwa(){
    oppswa
    npxStartSwa
}

function npxStartManSwa(){
    manswa
    npxStartSwa -reactPort 5173
}

#Start each portal: serve content, start API, start SWA
#currently not using above aliases as powershell profile won't load when starting new Windows Teminal tab
function startManage(){
    startPortal "BillingService.Swa" "BillingService.Swa.Api" 5173
}

function startInvest(){
    startPortal "InvestorDashboard.Swa" "InvestorDashboard.Api"
}

function startOperate(){
    startPortal "AssetOperatorPortal" "AssetOperatorPortal.Api"
}

function startPortal($swaPath, $apiPath, $reactPort = 3000, $apiPort = 7071, $swaPort = 4280){
    wt -w 0 new-tab --title "Serve Content" -d "C:\Users\adamf\source\repos\BillingService\$swaPath" pwsh -c "yarn start"
    wt -w 0 new-tab --title "API" -d "C:\Users\adamf\source\repos\BillingService\$swaPath\$apiPath" pwsh -c "func start"
    wt -w 0 new-tab --title "SWA" -d "C:\Users\adamf\source\repos\BillingService\$swaPath" pwsh -c "npx @azure/static-web-apps-cli@2.0.1 start http://localhost:$reactPort --api-location http://localhost:$apiPort"
    
    Start-Process chrome "http://localhost:$reactPort"
    Start-Process chrome "http://localhost:$apiPort"
    Start-Process chrome "http://localhost:$swaPort"
}

# dotnet test BillingService.IntegrationTests/BillingService.IntegrationTests.csproj