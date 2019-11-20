#!/bin/bash
pname gtk/gtk

# set gtk theme
# only works with gnome-settings-daemon or mate-settings-daemon running

### general utilities ###
gtkloop() {
    pushd "$1" &>/dev/null
    for i in ./*; do
        echo "$i"
        [ -e "$i"/index.theme ] || continue
        if grep -q "Name.*=$2.*" <./"$i"/index.theme; then
            return 0
        fi
    done
    return 1
    popd &>/dev/null
}

#### Theme utilities ####
gtktheme() {

    GNOMETHEME=$(dconf read "/org/gnome/desktop/interface/gtk-theme")
    if [ -n "$GNOMETHEME" ]; then
        dconf write /org/gnome/desktop/interface/gtk-theme "'$1'"
    fi

    MATETHEME=$(dconf read "/org/mate/desktop/interface/gtk-theme")
    if [ -n "$MATETHEME" ]; then
        dconf write /org/mate/desktop/interface/gtk-theme "'$1'"
    fi
}

themeexists() {
    if { gtkloop "~/.themes" "$1" || gtkloop '/usr/share/themes' "$1"; }; then
        echo "theme $1 exists"
        return 0
    else
        echo "theme $1 doesnt exist"
        return 1
    fi
}

### Icon set utilities ###
gtkicons() {

    GNOMEICONS=$(dconf read "/org/gnome/desktop/interface/icon-theme")
    if [ -n "$GNOMEICONS" ]; then
        dconf write /org/gnome/desktop/interface/icon-theme "'$1'"
    fi

    MATEICONS=$(dconf read "/org/mate/desktop/interface/icon-theme")
    if [ -n "$MATEICONS" ]; then
        dconf write /org/mate/desktop/interface/icon-theme "'$1'"
    fi
}

icons_exist() {
    if { gtkloop "~/.icons" "$1" || gtkloop '/usr/share/icons' "$1"; }; then
        echo "icons $1 exist"
        return 0
    else
        echo "icons $1 dont exist"
        return 1
    fi
}

### font utilities ###

fontexists() {
    if convert -list font | grep -iq "$1"; then
        echo "font $1 exists"
        return 0
    else
        echo "font $1 not found"
        return 1
    fi
}

installfont() {
    [ -n "$2" ] && fontexists $2 && return 0

    if [ -e ~/.local/share/fonts/"${1##*/}" ]; then
        echo "font file conflict"
        return 1
    fi
    mv "$1" ~/.local/share/fonts/
    echo "installed font $1"
}
