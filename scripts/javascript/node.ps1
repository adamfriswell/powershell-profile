function removeNodeModules(){
    Remove-Item -Path '.\node_modules' -Recurse -Force
}