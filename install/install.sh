#!/usr/bin/env bash

pinstall() {

    if ! sudo --version &>/dev/null; then
        source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
        pb sudo/fakesudo.sh
    fi

    if [ -z "$1" ]; then
        echo "usage pinstall packages"
        return
    fi

    if apt --version &>/dev/null; then
        sudo apt update && apt install -y "$@"
    fi

    if pacman --version &>/dev/null; then
        sudo pacman -S "$@"
    fi

    if apk --version &>/dev/null; then
        apk add --update "$@"
    fi

}
