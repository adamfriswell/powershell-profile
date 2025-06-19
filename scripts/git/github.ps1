<#
.SYNOPSIS
    Try and connect GPG agent
#>
function gpgAgentFix(){
    gpg-connect-agent
}

<#
.SYNOPSIS
    View last PR in browser
#>
function lastPr(){
    gh pr view --web
}