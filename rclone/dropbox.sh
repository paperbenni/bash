#!/usr/bin/env bash
pname rclone/dropbox
addbox() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "usage: addbox name token"
        return 0
    fi
    pb replace
    mkdir ~/.config/rclone
    pushd ~/.config/rclone
    curl https://raw.githubusercontent.com/paperbenni/bash/master/rclone/conf/dropbox.conf >>rclone.conf
    rpstring "dropname" "$1" rclone.conf
    rpstring "droptoken" "$2" rclone.conf
    popd
}
