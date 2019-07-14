#!/usr/bin/env bash

pname flask/listen

flisten() {
    # create the listener if it doesn't exist
    APPENDFILE="listener.py"

    if ! [ -e listener.py ]; then
        if ! python3 -c 'import flask'; then
            if command -v sudo; then
                sudo pip3 install flask
            else
                pip3 install flask
            fi
        fi
        touch listener.py
        app '#!usr/bin/env python3'
        app 'from flask import Flask, escape, request'
        app 'import os'
        app 'app = Flask(__name__)'
    else
        if cat listener.py | grep "${1}name"; then
            echo "$1 already listening"
            return 1
        fi
    fi

    app "@app.route('/$1/<${1}name>')"
    app "def show_user_profile(${1}name):"
    app "   print(${1}name)"
    app '   f=open("'"${1}name.txt"'", "a+")'
    app "   f.write( ${1}name + '\n')"
    app "   return 'registered %s' % ${1}name"

}

frun() {
    FLASK_APP=${1:-listener.py}
    PORT=${PORT:-5000}
    if ! [ -e $FLAPP ]; then
        echo "flask file $FLAPP not found"
        return 1
    fi

    while true; do
        flask run --host=0.0.0.0 --port=$PORT
        echo "flask exited"
        sleep 2
    done &
}
