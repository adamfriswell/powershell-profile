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

function UnpinAppVerbose([string]$appname) {
    $debug = $false

    # Create the Shell.Application COM object
    $shellApp = New-Object -Com Shell.Application
    
    # Access the taskbar namespace using the GUID
    $taskbarNamespace = $shellApp.NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}')
    
    # Check if the taskbar namespace is valid (not null)
    if ($null -eq $taskbarNamespace) {
        Write-Host "Failed to access taskbar namespace"
        return
    }
    
    # Get the items in the taskbar namespace
    $taskbarItems = $taskbarNamespace.Items()
    
    # Find the item that matches the app name
    $appItem = $taskbarItems | Where-Object { $_.Name -eq $appname }
    
    # Check if the app item was found
    if ($null -eq $appItem) {
        if($debug){
            Write-Host "App not found on the taskbar"
        }
        return
    }
    
    # Get the verbs (actions) associated with the app item
    $appVerbs = $appItem.Verbs()
    
    # Find the "Unpin from taskbar" verb
    $unpinVerb = $appVerbs | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' }
    
    # Check if the unpin verb was found
    if ($null -eq $unpinVerb) {
        if($debug){
            Write-Host "Unpin from taskbar action not found"
        }
        return
    }
    
    # Perform the "Unpin from taskbar" action
    $unpinVerb.DoIt()
    Write-Host "$appname has been unpinned from the taskbar."
}

function reload(){
    Start-Process PowerShell # Launch PowerShell host in new window
    exit # Exit existing PowerShell host window
}