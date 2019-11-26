#!/usr/bin/env bash
pname dialog/dmenu

# yes/no chooser
dconfirm() {
    echo "yes" >~/.doptions
    echo "no" >>~/.doptions
    CHOICE=$(dmenu <~/.doptions)
    case $CHOICE in
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
    yres=$(awk '/dimensions:/ {sub(/[0-9]+x/, ""); print($2); exit 0}' <(xdpyinfo))

    while [ -e ~/.dpopped ]; do
        CLOUDMENU=$(echo "$1" | dmenu -y $[yres / 2] -p "please wait" -l 10)
        [ "$CLOUDMENU" = "pb" ] && break
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
        [[ -d $newdir && $newdir != *[:,-]* ]] && cd "$newdir" || break
        newdir=$(ls | grep -E '^[^\$].*' | dmenu -l 30)
    done
    realpath "$newdir"
    popd &>/dev/null
}
