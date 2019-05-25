#!/usr/bin/env bash
pname rclone/login

rcloud() {
    if [ -z "$1" ]; then
        echo "usage: rcloud remotename"
        return 1
    fi

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

#log into your remote folder account
rclogin() {
    USAGE="rclogin [remote name] username password"
    [ "$1" = "help" ] && echo "$USAGE" && return 0
    RCLOUD="$1"

    command -v rclone || return
    rcloud "$1" || return

    mkdir ~/.rclogin &>/dev/null
    pushd ~/.rclogin

    #add the remote to rclone.conf

    #save creds in ~/.rclogin
    if [ -e "$RCLOUD".conf ]; then
        echo "using existing credentials"
        RNAME=$(cat "$RCLOUD.conf" | grep "username:" | egrep -o ':.*' |
            egrep -o "[^:].*")
        echo "$RNAME"

        RPASS=$(cat "$RCLOUD.conf" | grep "password:" | egrep -o ':.*' |
            egrep -o "[^:].*")
    else
        if [ -z "$3" ]; then
            pb dialog
            RNAME=$(textbox "username")
            RPASS=$(textbox "password")
        else
            RNAME="$2"
            RPASS="$3"
        fi
        echo "username:$RNAME" >>"$RCLOUD.conf"
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
            popd
            rm ~/.rclogin/"$RCLOUD".*
            rm ~/.config/rclone/rclone.conf
            rclogin "$RCLOUD"
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
