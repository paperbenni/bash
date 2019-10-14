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
    touch ~/.dpopped
    yres=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/' | egrep -o '[^x]*$')

    while [ -e ~/.dpopped ]; do
        CLOUDMENU=$(echo "$1" | dmenu -y $(expr $yres / 2) -p "please wait" -l 10)
        if [ "$CLOUDMENU" = "pb" ]; then
            break
        fi
        sleep 0.5
    done &

    sleep ${2:-60}
    rmdpop
}

rmdpop() {
    pkill dmenu
    rm ~/.dpopped
}

dtext() {
    echo '' | dmenu -p "$1"
}
