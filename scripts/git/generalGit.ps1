#gmp = git main pull
function gmp($branch){
    git checkout main
    git pull
    if($branch){
        git checkout -b $branch
    }
}

#gmm = git main merge
function gmm(){
    #$branch = git rev-parse --abbrev-ref HEAD
    git checkout main
    git pull
    git checkout - #$branch
    git merge main
    git add .
    git push
}