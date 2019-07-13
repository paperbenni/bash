#!/usr/bin/env bash

pname flask/listen

flisten() {
    # create the listener if it doesn't exist
    APPENDFILE="listener.py"
    if cat listener.py | grep "${1}name"; then
        echo "$1 already listening"
        return 1
    fi

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
    fi

    app "@app.route('/$1/<${1}name>')"
    app "def show_user_profile(${1}name):"
    app "   print(${1}name)"
    app '   f=open("'"${1}name.txt"'", "a+")'
    app "   f.write( ${1}name + '\n')"
    app "   return 'registered %s' % ${1}name"

}

frun() {
    while true; do
        PORT=${PORT:-5000}
        env FLASK_APP=$1 flask run --host=0.0.0.0 --port=$PORT
        echo "flask exited"
        sleep 2
    done
}
