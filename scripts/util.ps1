function IsAdmin(){
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function FindFile($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}

function FindPort($port){
    netstat -ano | findstr :$port
}

function KillPort($processId){
    taskkill /PID $processId /F
}

function UnpinApp([string]$appname) {
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() |
        Where-Object{$_.Name -eq $appname}).Verbs() | 
        Where-Object{$_.Name.replace('&','') -match 'Unpin from taskbar'} | 
        ForEach-Object{$_.DoIt()}
}
