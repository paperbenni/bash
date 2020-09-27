#!/bin/bash

pname instantos/install

ibuild() {
    if [ -z "$1" ]; then
        echo "usage:"
        echo "ibuild packagename"
        exit
    fi

    if ! [ -e ~/workspace/extra ]; then
        mkdir ~/workspace
        cd ~/workspace
        git clone --depth=1 https://github.com/instantos/extra
        cd extra
        if [ -e "$1/PKGBUILD" ]
        then
            mkdir -p ~/.cache/instantos/pkg
            cp -r "$1" ~/.cache/instantos/pkg/
            cd ~/.cache/instantos/pkg/
        fi
    fi
}
