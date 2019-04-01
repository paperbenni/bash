#!/usr/bin/env bash

# wrapper for the safaribooks downloader
safari() {
    if ! [ -e .config/safari/password.txt ] || [ "$1" = "login" ]; then
        mkdir -p ~/.config/safari
        pushd ~/.config/safari
        echo "please log into your account"
        echo "email"
        read email
        echo "password"
        read password
        echo "$email" >email.txt
        echo "$password" >password.txt
        popd
    fi

    SEMAIL=$(cat ~/.config/safari/email.txt)
    SPASS=$(cat ~/.config/safari/password.txt)

    mkdir ~/books
    for arg in "$@"; do
        safaribooks-downloader -b "$arg" -u "$SEMAIL" -p "$SPASS" -o ~/books/"$arg".epub
    done
    echo "done"
}
