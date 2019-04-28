#!/usr/bin/env bash
pname heroku/heroku

htime() {
    heroku ps -a "$1" | grep 'usage' | egrep -o '[0-9]*%' | egrep -o '[0-9]*'
}

hlogin() {
    cd
    rm .netrc
    pb replace
    cat netrc || \
    wget https://raw.githubusercontent.com/paperbenni/bash/master/heroku/netrc
    cp netrc .netrc
    rpstring loginmail "$1" .netrc
    rpstring loginpassword "$2" .netrc
}
