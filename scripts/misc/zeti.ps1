$billingServicePath = "C:\Users\adamf\source\repos\BillingService"

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
function startSwa(){
    swa start http://localhost:3000 --api-location http://localhost:7071
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
    startSwa
}

#All in one
function localInv(){
    serveInvContent
    wt new-tab

    startInvApi
    wt new-tab

    startInvSwa
}

function localOpp(){
    serveOppContent
    wt new-tab

    startOppApi
    wt new-tab

    startOppSwa
}

function localMan(){
    serveManContent
    wt new-tab

    startManApi
    wt new-tab

    startManSwa
}