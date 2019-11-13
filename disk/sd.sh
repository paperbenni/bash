#!/bin/bash
pname disk/sd
mountimage() {
    sudo mkdir -p /media/sdcard
    { [ -f "$1" ] && [[ "$1" == *.raw ]]; } || return 1
}
