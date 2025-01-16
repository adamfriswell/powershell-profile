#Create branch, update matching pacages, commit and create PR
function nugetUpdate($ticket, $pkg, $commitMsg, $prTitle, $prDesc){
    gmp -branch $ticket 
    dotnet outdated -inc $pkg -u
    git add .
    git commit -m $commitMsg
    git push --set-upstream origin $ticket
    gh pr create --title "[$ticket] $prTitle" --body $prDesc
    gh pr view
}