#!/usr/bin/env bash

rlogin() {
    USAGE="rlogin [remote name] username password"
    if ! rclone --version; then
        echo "please install rclone"
        exit
    fi

    if [ -z "$1" ]; then
        RCLOUD="$1"
        if [ -z "$3" ]; then
            exit
        fi
        RNAME="$2"
        RPASS="$3"
    else
        if [ -z "$2" ]; then
            exit
        fi
        RCLOUD="mega"
        RNAME="$1"
        RPASS="$2"
    fi

    if rclone lsd "$RCLOUD":"$RNAME"; then
        echo "account found"
        MEGAPASSWORD=$(rclone cat "$RCLOUD":"$USERNAME"/password.txt)
        if [ "$MEGAPASSWORD" = "$RPASS" ]; then
            echo "login sucessfull"
            sleep 1
            exit 0
        else
            echo "wrong password"
            sleep 3
            exit 1
        fi
    else
        echo "account not found, creating account"
        rclone mkdir "$RCLOUD":"$USERNAME"
        echo "$RPASS" > password.txt
        rclone copy password.txt "$RCLOUD":"$RNAME"/
        rm password.txt
        echo "account created"
        exit 0
    fi

}
