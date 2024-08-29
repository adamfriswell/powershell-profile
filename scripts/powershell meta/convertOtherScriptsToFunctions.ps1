#Script to generate a PowerShell function from an existing script file.

# Define the path to the .ps1 file
$userName="YOUR USERNAME"
$path = "C:\Users\$userName\OneDrive - NewDay Cards Ltd\Documents\_scripts"
$files = @("gitImport.ps1") #, "nuget.ps1")

foreach($file in $files){
    $filePath = "$path\$file"

    # Get the file name without extension
    $functionName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)

    # Read the contents of the .ps1 file
    $fileContent = Get-Content -Path $filePath -Raw

    # Create the function definition
    $functionDefinition = @'
   function $functionName {
        $fileContent
    }
'@ -f $functionName, $fileContent

    # Output the function definition to a new .ps1 file or to the console
    # To save to a new file:
    $outputFilePath = "$path\function_$functionName.ps1"
    $functionDefinition | Out-File -FilePath $outputFilePath
}