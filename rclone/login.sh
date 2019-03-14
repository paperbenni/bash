#!/usr/bin/env bash

rlogin() {

    mkdir ~/.rlogin
    pushd ~/.rlogin

    USAGE="rlogin [remote name] username password"
    if ! rclone --version > /dev/null; then
        echo "please install rclone"
        popd
        return
    fi

    if ! [ -z "$3" ]; then
        RCLOUD="$1"
        RNAME="$2"
        RPASS="$3"
    else
        if [ -z "$2" ]; then
            popd
            return
        fi
        RCLOUD="mega"
        RNAME="$1"
        RPASS="$2"
    fi

    if rclone lsd "$RCLOUD":"$RNAME" &> /dev/null; then
        echo "account found"
        MEGAPASSWORD=$(rclone cat "$RCLOUD":"$USERNAME"/password.txt)
        if [ "$MEGAPASSWORD" = "$RPASS" ]; then
            echo "login sucessfull"
            sleep 1
            popd
            return 0
        else
            echo "wrong password"
            sleep 3
            popd
            return 1
        fi
    else
        echo "account not found, creating account"
        rclone mkdir "$RCLOUD":"$USERNAME"
        echo "$RPASS" >password.txt
        rclone copy password.txt "$RCLOUD":"$RNAME"/
        rm password.txt
        echo "account created"
        popd
        return 0
    fi

}
