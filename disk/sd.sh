#!/bin/bash
pname disk/sd
mountimage() {
    if ! [ -e /media/sdcard ]; then
        sudo mkdir /media/sdcard
    fi
    if ! [ -e "$1" ]; then
        return 1
    fi
    if ! echo "$1" | grep '\.raw'; then
        return 1
    fi
}
