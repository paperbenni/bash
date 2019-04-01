#!/usr/bin/env bash

#creates a launcher for a directory containing scripts in /bin
bashlauncher() {
    if [ -z "$1" ]; then
        echo "usage: bashlauncher directory name"
        return
    fi

    if [ -e /bin/"$2" ]; then
        echo "please chose another name"
        return
    fi

    if [ -d "$1" ]; then
        chmod +x "$1"/*.sh
        LAUNCHDIR=$(realpath "$1")
        cd /tmp
        curl -s "https://raw.githubusercontent.com/paperbenni/bash/master/pb/launch.sh" >"$2"
        sed -i -e "s/pastedirhere/$LAUNCHDIR/g" "$2"
        chmod +x "$2"
        sudo mv "$2" /bin
    fi
}
