#!/usr/bin/env bash
pname heroku/heroku

htime() {
    heroku ps -a "$1" | grep 'usage' | egrep -o '[0-9]*%' | egrep -o '[0-9]*'
}

hlogin() {
    echo "logging in $1"
    cd "$HOME"
    pwd
    rm .netrc
    pb replace
    cat netrc ||
        wget https://raw.githubusercontent.com/paperbenni/bash/master/heroku/netrc
    cp netrc .netrc
    rpstring loginmail "$1" .netrc
    rpstring loginpassword "$2" .netrc
    cat .netrc
}

isheroku() {
    if [ -n "$HEROKU_APP_NAME" ] || [ -n "$HEROKU" ]; then
        echo "heroku detected"
        return 0
    else
        echo "not running in heroku"
        return 1
    fi
}
