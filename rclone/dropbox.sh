#!/usr/bin/env bash
pname rclone/dropbox
addbox() {
    if [ -z "$1" ]; then
        echo "usage: addbox [name] token"
        return 0
    fi

    pb replace
    mkdir -p .config/rclone
    cd .config/rclone
    curl -s https://raw.githubusercontent.com/paperbenni/bash/master/rclone/conf/dropbox.conf >>rclone.conf
    rpstring "dropname" "${2:-dropbox}" rclone.conf
    rpstring "droptoken" "$1" rclone.conf

}
