#!/usr/bin/env bash

pinstall() {

    if [ -z "$@" ]; then
        echo "usage pinstall packages"
        exit
    fi

    if apt --version; then
        apt update && apt install -y "$@"
    fi

    if pacman --version; then
        pacman -S "$@"
    fi

    if apk --version; then
        apk add --update "$@"
    fi

}
