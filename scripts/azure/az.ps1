<#
.SYNOPSIS
    Get Azure access token for a pillar/env
#>
function azToken($pillar, $env){
    $scope = "api://ndt-$pillar-$env/.default"
    AZ account get-access-token --scope $scope
}

<#
.SYNOPSIS
    Validate an Azure Resource Manager (ARM) template
#>
function validateArmTemplate($rg, $templateFile, $params){
    az deployment group validate --resource-group $rg --template-file $templateFile --parameters $params
}