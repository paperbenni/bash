#!/usr/bin/env bash
pname safaribooks/download
# wrapper for the safaribooks downloader
safari() {
    if ! command -v safaribooks-downloader; then
        cd
        git clone https://github.com/nicohaenggi/SafariBooks-Downloader.git
        cd SafariBooks-Downloader
        npm install
        sudo npm install -g
        cd
    fi

    if ! [ -e .config/safari/password.txt ] || [ "$1" = "login" ]; then
        mkdir -p ~/.config/safari
        pushd ~/.config/safari
        echo "please log into your account"
        pb dialog
        echo "$(textbox email)" >email.txt
        echo "$(textbox password)" >password.txt
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
