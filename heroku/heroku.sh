#!/usr/bin/env bash
pname heroku/heroku

htime() {
    heroku ps -a "$1" | grep 'usage' | egrep -o '[0-9]*%' | egrep -o '[0-9]*'
}

hlogin() {

    test -e ~/hlogin.sh ||
        (
            curl "https://raw.githubusercontent.com/paperbenni/bash/master/heroku/login.sh" >~/hlogin.sh
            chmod +x ~/hlogin.sh
        )
    ~/hlogin.sh "$1" "$2"
    if command -v docker; then
        echo "logging in docker"
        heroku container:login
    fi
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
