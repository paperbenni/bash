#!/usr/bin/env bash

#check if a file is a directory
pname rclone/rclone

rcheck() {
    rclone rmdir -vv --dry-run "$RCLOUD":"$RNAME/$1" &>/dev/null
}

rexists() {
    if rclone ls "$RCLOUD":"$RNAME/$1" &>/dev/null; then
        echo "$1 exists"
        return 0
    else
        echo "$1 does not exist on remote"
        return 1
    fi
}

#download a file or directory from your account folder
rdl() {
    if ! rexists "$1"; then
        echo "file does not exist on remote"
        return 1
    fi
    if rcheck "$1"; then
        echo "downloading folder $1"
        if [ -z "$2" ]; then
            rclone copy "$RCLOUD":"$RNAME"/"$1" ./"$1"
        else
            rclone copy "$RCLOUD":"$RNAME"/"$1" ./"$2"/"$1"
        fi
        mkdir -p ./"$1"
    else
        echo "downloading file $1"

        if [ -z "$2" ]; then
            rclone copy "$RCLOUD":"$RNAME"/"$1" ./
        else
            rclone copy "$RCLOUD":"$RNAME"/"$1" ./
            mv "$1" "$2"
        fi
    fi
}

#upload a local folder to your account remote folder
rupl() {
    if ! [ -e "$1" ]; then
        echo "file or directory not found"
    fi

    if [ -z "$2" ]; then
        if [ -d "$1" ]; then
            echo "uploading folder $1"
            rclone copy "$1" "$RCLOUD":"$RNAME"/"$1.1" || (echo "upload failed, exiting..." && return 1)
            echo "uploading $1 done"
            rrm "$1"
            rmove "$1.1" "$1"
        else
            echo "uploading file $1"
            mv "$1" "$1.1"
            rclone copy "$1.1" "$RCLOUD":"$RNAME" || (echo "upload failed, exiting..." && return 1)
            rrm "$1"
            mv "$1.1" "$1"
            echo "uploading $1 done"
            rmove "$1.1" "$1"

        fi
    else
        if [ -d "$1" ]; then
            echo "uploading folder $1"
            rclone copy "$1" "$RCLOUD:$RNAME/$2/$1.1" || (echo "upload failed, exiting..." && return 1)
            echo "uploading $1 done"
            rrm "$2/$1"
            rmove "$2/$1.1" "$2/$1"
        else
            echo "uploading file $1"
            rclone copy "$1" "$RCLOUD:$RNAME/$2.1" || (echo "upload failed, exiting..." && return 1)
            echo "uploading $1 done"
            rrm "$2"
            rmove "$2.1" "$2"
        fi
    fi
}

#rupl but with sync instead of copy
rupls() {
    if ! [ -e "$1" ]; then
        echo "file or directory not found"
    fi

    if [ -z "$2" ]; then
        if [ -d "$1" ]; then
            echo "synchronizing folder $1"
            rclone sync "$1" "$RCLOUD":"$RNAME"/"$1"
        else
            echo "synchronizing file $1"
            rclone sync "$1" "$RCLOUD":"$RNAME"
        fi
    else
        if [ -d "$1" ]; then
            echo "synchronizing folder $1"
            rclone sync "$1" "$RCLOUD":"$RNAME"/"$2"/"$1"
        else
            echo "synchronizing file $1"
            rclone sync "$1" "$RCLOUD":"$RNAME"/"$2"
        fi
    fi
}

# append string to rclone.conf file
rappend() {
    if ! [ -e "$HOME"/.config/rclone/rclone.conf ]; then
        mkdir -p "$HOME/.config/rclone"
    fi
    pushd "$HOME/.config/rclone" || return 1
    echo "$1" >>rclone.conf
}

#add a mega storage to rclone.conf
rmega() {
    if [ -z "$3" ]; then
        APPENDCLOUD="mega"
    else
        APPENDCLOUD="$3"
    fi

    if (grep -q "$1" <"$HOME/.config/rclone/rclone.conf"); then
        echo "remote name already existing"
        return
    fi
    rappend "[$APPENDCLOUD]"
    rappend "type = mega"
    rappend "user = $1"
    rappend "pass = $2"

}

#mount a folder from your account remote
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

rmove() {
    rexists "$1" || return 1
    rclone moveto "$RCLOUD:$RNAME/$1" "$RCLOUD:$RNAME/$2"
}

rrm() {
    rexists "$1" || (echo "cannot remove this" && return 0)
    if rcheck "$1"; then
        echo "removing directory $1"
        rclone purge --mega-hard-delete "$RCLOUD:$RNAME/$1"
    else
        echo "removing file $1"
        rclone delete --mega-hard-delete "$RCLOUD:$RNAME/$1"
    fi
}
