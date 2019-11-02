#!/usr/bin/env bash
pname dialog/dmenu

# yes/no chooser
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

# get sudo password
dsudo() {
    test -n "$SUDOPASS" || SUDOPASS=$(echo '' | dmenu -P -p "sudo password")
    printf "$SUDOPASS" | sudo -S "$@"
}

# I have no idea
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

# display text
dtext() {
    echo '' | dmenu -p "$1"
}

# file chooser
dfile() {
    pushd . &>/dev/null
    cd
    newdir='.'
    while [ -n "$newdir" ]; do
        if echo "$newdir" | grep -i '[:,-]' &>/dev/null; then
            break
        fi
        if [ -e "$newdir" ]; then
            cd "$newdir"
        else
            break
        fi
        newdir=$(ls | egrep '^[^\$].*' | dmenu -l 30)
    done
    realpath "$newdir"
    popd &>/dev/null
}
