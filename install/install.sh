#!/usr/bin/env bash

pinstall() {

    if [ -z "$1" ]; then
        echo "usage pinstall packages"
        return
    fi

    if apt --version &>/dev/null; then
        apt update && apt install -y "$@"
    fi

    if pacman --version &>/dev/null; then
        pacman -S "$@"
    fi

    if apk --version &>/dev/null; then
        apk add --update "$@"
    fi

}
