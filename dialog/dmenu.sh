#!/usr/bin/env bash
pname dialog/dmenu

dconfirm() {
    echo "yes" >~/.doptions
    echo "no" >>~/.doptions
    CHOICE=$(dmenu <~/.doptions)
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
    test -n "$SUDOPASS" || SUDOPASS=$(echo '' | dmenu -P -p "sudo password")
    printf "$SUDOPASS" | sudo -S "$@"
}

dpop() {
    yres=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/' | egrep -o '[^x]*$')
    echo 'ok' | dmenu -y $(expr $yres / 2) -p "$1" -l 10 &
    sleep 5
    if pgrep dmenu; then
        pkill dmenu
    fi
}

dtext() {
    echo '' | dmenu -p "$1"
}
