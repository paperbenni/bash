#!/usr/bin/env bash

pname flask/listen

flisten() {
    # create the listener if it doesn't exist
    if ! [ -e ~/pbflask/listener.py]; then
        if ! python -c 'import flask'; then
            if command -v sudo; then
                sudo pip3 install flask
            else
                pip3 install flask
            fi
        fi
        cd
        mkdir pbflask
        touch listener.py
        APPENDFILE="listener.py"
        app '#!usr/bin/env python3'
        app 'import flask'
        app 'import os'
    fi
}
