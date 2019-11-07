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

# clone one of my repos. just here for backwards compatibility
papergit() {
    git clone --depth 1 "https://github.com/paperbenni/$1"
}

# clone repo, default to github, default to my username
gitclone() {
    zerocheck "$1"
    if grep ':' <<<"$1"; then
        git clone --depth=1 "$1"
    else
        if grep '/' <<<"$1"; then
            git clone --depth=1 "https://github.com/$1.git"
        else
            git clone --depth 1 "https://github.com/paperbenni/$1"
        fi
    fi
}
