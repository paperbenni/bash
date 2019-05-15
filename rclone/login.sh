#!/usr/bin/env bash
pname rclone/login

#log into your remote folder account
rclogin() {

    mkdir ~/.rclogin &>/dev/null
    pushd ~/.rclogin

    if ! [ -e ~/.config/rclone/rclone.conf ]; then
        echo "setting up default cloud"
        curl -s https://raw.githubusercontent.com/paperbenni/bash/master/rclone/conf/mineglory.conf >~/.config/rclone/rclone.conf
    fi

    USAGE="rclogin [remote name] username password"
    [ "$1" = "help" ] && echo "$USAGE"

    if ! rclone --version >/dev/null; then
        echo "please install rclone"
        popd
        return
    fi
    if ! [ -z "$1" ]; then
        RCLOUD="$1"
    else
        echo "enter cloud storage name"
        read RCLOUD
    fi

    rm .conf &>/dev/null
    if [ -e "$RCLOUD".conf ]; then
        echo "using existing credentials"
        RNAME1=$(grep "username:" <"$RCLOUD".conf)
        RNAME=${RNAME1#*\:}
        echo "$RNAME"
        RPASS1=$(grep "password:" <"$RCLOUD".conf)
        RPASS=${RPASS1#*\:}
    else
        if [ -z "$2" ]; then
            touch username
            while test -z $(cat username); do
                dialog --inputbox "Enter your username:" 8 40 2>username
            done
            RNAME=$(cat username)
            rm username
        else
            RNAME="$2"

        fi
        echo "username:$RNAME" >>"$RCLOUD.conf"

        if [ -z "$3" ]; then
            touch password
            while test -z $(cat password); do
                dialog --inputbox "Enter your password:" 8 40 2>password
            done
            RPASS=$(cat password)
            rm password
        else
            RPASS="$3"
        fi
        echo "password:$RPASS" >>"$RCLOUD.conf"
    fi

    if rclone lsd "$RCLOUD":"$RNAME" &>/dev/null; then
        echo "account found"
        MEGAPASSWORD=$(rclone cat "$RCLOUD":"$RNAME"/password.txt)
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
        rclone mkdir "$RCLOUD":"$RNAME"
        rclone mkdir "$RCLOUD":"$RNAME"/thisaccountexists
        echo "$RPASS" >password.txt
        rclone copy password.txt "$RCLOUD":"$RNAME"/
        rm password.txt
        echo "account created"
        popd
        return 0
    fi
}

rcloud() {
    mkdir -p ~/.config/rclone

    pushd ~/.config/rclone
    test -e rclone.conf || touch rclone.conf
    if grep "$1" <rclone.conf; then
        echo "rclone remote with name $1 already existing"
        return 0
    fi
    curl -s "https://raw.githubusercontent.com/paperbenni/rcloud/master/$1.conf" >>rclone.conf
    echo "added remote $1"
    popd

}
