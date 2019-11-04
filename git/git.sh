#!/usr/bin/env bash
pname git/git

gitfolder() {
    svn export https://github.com/"$1".git/trunk/"$2"
}

ghrepos() {
    GHUSER="$1"
    curl -s "https://api.github.com/users/$GHUSER/repos?per_page=100" | grep -E -o 'git@[^"]*' | grep -o ':.*' | grep -E -o '[^:]*'
}

ghbackup() {
    for repo in $(ghrepos $1); do
        git clone "https://github.com/$repo"
    done
}

papergit(){
	git clone --depth 1 "https://github.com/paperbenni/$1"
}
