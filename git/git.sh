#!/usr/bin/env bash
pname git/git

gitfolder() {
    svn export https://github.com/"$1".git/trunk/"$2"
}

ghrepos() {
    GHUSER="$1"
    curl "https://api.github.com/users/$GHUSER/repos?per_page=100" | grep -o 'git@[^"]*'
}
