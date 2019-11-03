#!/bin/bash
pname archsetup/setup

archsetup() {

    sudo pacman -Syu

    if [ -e ./programs.txt ]; then
        echo "program list found"
    else
        echo "no list found" >&2
        return 1
    fi

    for THISPROGRAM in $(< ./programs.txt); do
        sudo pacman -Sy $THISPROGRAM
    done

}
