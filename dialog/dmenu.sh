#!/usr/bin/env bash
pname dialog/dmenu

dconfirm() {
    echo "yes" >~/.doptions
    echo "no" >>~/.doptions
    CHOICE=$(cat ~/.doptions | dmenu)
    case "$CHOICE" in
    yes)
        return 0
        ;;
    no)
        return 1
        ;;
    esac
}

dsudo() {
    test -n "$SUDOPASS" || SUDOPASS=$(echo '' | dmenu -p "sudo password")
    printf "$SUDOPASS" | sudo -S "$@"
}
