#!/usr/bin/env bash

rcheck() {
    rclone rmdir -vv --dry-run "$RCLOUD":"$RNAME/$1" &>/dev/null
}

rdl() {
    DIRLIST=$(rclone lsd "$RCLOUD":"$RNAME")
    if rcheck "$1"; then
        echo "downloading folder"
        if [ -z "$2" ]; then
            rclone copy "$RCLOUD":"$RNAME"/"$1" ./"$1"
        else
            rclone copy "$RCLOUD":"$RNAME"/"$1" ./"$2"/"$1"
        fi
    else
        echo "downloading file"

        if [ -z "$2" ]; then
            rclone copy "$RCLOUD":"$RNAME"/"$1" ./
        else
            rclone copy "$RCLOUD":"$RNAME"/"$1" ./
            mv "$1" "$2"
        fi
    fi
}

rupl() {
    if ! [ -e "$1" ]; then
        echo "file or directory not found"
    fi

    if [ -z "$2" ]; then
        if [ -d "$1" ]; then
            echo "uploading folder"
            rclone copy "$1" "$RCLOUD":"$RNAME"/"$1"
        else
            echo "uploading file"
            rclone copy "$1" "$RCLOUD":"$RNAME"
        fi
    else
        if [ -d "$1" ]; then
            echo "uploading folder"
            rclone copy "$1" "$RCLOUD":"$RNAME"/"$2"/"$1"
        else
            echo "uploading file"
            rclone copy "$1" "$RCLOUD":"$RNAME"/"$2"
        fi
    fi
}

rupls() {
    if ! [ -e "$1" ]; then
        echo "file or directory not found"
    fi

    if [ -z "$2" ]; then
        if [ -d "$1" ]; then
            echo "synchronizing folder"
            rclone sync "$1" "$RCLOUD":"$RNAME"/"$1"
        else
            echo "synchronizing file"
            rclone sync "$1" "$RCLOUD":"$RNAME"
        fi
    else
        if [ -d "$1" ]; then
            echo "synchronizing folder"
            rclone sync "$1" "$RCLOUD":"$RNAME"/"$2"/"$1"
        else
            echo "synchronizing file"
            rclone sync "$1" "$RCLOUD":"$RNAME"/"$2"
        fi
    fi
}

rappend() {
    if ! [ -e "$HOME"/.config/rclone/rclone.conf ]; then
        mkdir -p "$HOME/.config/rclone"
    fi
    pushd "$HOME/.config/rclone" || return 1
    echo "$1" >>rclone.conf
}

rmega() {
    if [ -z "$3" ]; then
        APPENDCLOUD="mega"
    else
        APPENDCLOUD="$3"
    fi

    if (cat "$HOME/.config/rclone/rclone.conf" | grep -q "$1"); then
        echo "remote name already existing"
        return
    fi
    rappend "[$APPENDCLOUD]"
    rappend "type = mega"
    rappend "user = $1"
    rappend "pass = $2"

}

rmount() {
    echo "$@" || (echo "usage: rcmount dir dest" && return 0)

    if [ -z "$2" ]; then
        DESTDIR="$1"
    else
        DESTDIR="$2"
    fi

    if ! [ -e "$DESTDIR" ]; then
        mkdir "$DESTDIR"
    fi

    if ! rclone lsd "$RCLOUD:$RNAME/$1"; then
        rclone mkdir "$RCLOUD:$RNAME/$1"
    fi

    rclone mount "$RCLOUD:$RNAME/$1" "$DESTDIR"
}
