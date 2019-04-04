#!/usr/bin/env bash

function confset() {
    if ! [ -e "$1" ]; then
        echo "target config file $1 not existing!"
        return 1
    fi
    if [ -z "$3" ]; then
        echo "usage: confset file option value"
    fi
    if grep "$2=$3" <"$1"; then
        echo "value $2=$3 already set"
        return 0
    else
        echo "setting $2=$3"
    fi
    NEWVALUE="$2=$3"
    sed -i "/^$2=/c $NEWVALUE" "$1"
    grep "$2" <"$1"
}
