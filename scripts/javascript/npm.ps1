<#
.SYNOPSIS
    List all globally installed npm packages
#>
function npmPackages() {
    npm list -g --depth 0
}