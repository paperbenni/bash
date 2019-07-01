#!/usr/bin/env bash
pname heroku/heroku

htime() {
    heroku ps -a "$1" | grep 'usage' | egrep -o '[0-9]*%' | egrep -o '[0-9]*'
}

hlogin() {
    echo "logging in $1"
    cd "$HOME"
    pwd
    rm .netrc &>/dev/null
    touch .netrc
    HPSS=$(echo "$2" | sed 's/#/\\#/g')
    
    APPENDFILE='.netrc'
    app 'machine api.heroku.com'
    app "  login $1"
    app "  password $HPSS"
    app "machine git.heroku.com"
    app "  login $1"
    app "  password $HPSS"
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
