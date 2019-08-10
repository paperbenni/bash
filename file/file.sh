#!/usr/bin/env bash

pname file/file

waitforfile() {
    while :; do
        if [ -e "$1" ]; then
            echo "file $1 found"
            break
        fi
        echo "waiting for $1"
        sleep 10
    done
}

filecheck() {
    if [ -e "$1" ]; then
        return 0
    else
        echo "$2"
        return 1
    fi
}
