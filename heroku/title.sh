#!/usr/bin/env bash
pname heroku/title

herokutitle() {

    if [ -z "$PORT" ]; then
        echo "$PORT not found"
        return 0
    fi

    pb titlesite
    titlesite glitch quark "$1" "$2"

    while :; do
        echo "checking web server"
        if ! pgrep httpd; then
            echo "web server not found, starting httpd"
            httpd -p 0.0.0.0:"$PORT" -h quark
            sleep 2
        else
            echo "web server found"
            sleep 5m
        fi
        if [ -n "$HEROKU_APP_NAME" ]; then
            curl "$HEROKU_APP_NAME.herokuapp.com" | grep "$1" &
            sleep 2
        fi
    done &

}
