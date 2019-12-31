#!/bin/bash
pname gtk/gtk

# set gtk theme
# only works with gnome-settings-daemon or mate-settings-daemon running

### general utilities ###

# initializes gtk3 config files
gtk3settings() {
    [ -e ~/.config/gtk-3.0/settings.ini ] ||
        mkdir -p ~/.config/gtk-3.0 &>/dev/null &&
        echo "[Settings]" >>~/.config/gtk-3.0/settings.ini

}

# checks if either a theme or icon set exists in folder $1
gtkloop() {
    pushd . &>/dev/null
    cd $1
    echo $1
    for i in ./*; do
        [ -e "$i"/index.theme ] || continue
        if grep -iq "Name.*=$2.*" <./"$i"/index.theme; then
            popd
            return 0
        fi
    done
    popd &>/dev/null
    return 1
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
    gtk3settings
    # set gtk3 settings
    if grep -q 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini; then
        sed -i 's/gtk-theme-name=.*/gtk-theme-name='"$1"'/g' ~/.config/gtk-3.0/settings.ini
    else
        echo "gtk-theme-name=$1" >>~/.config/gtk-3.0/settings.ini
    fi

    if grep -q 'gtk-theme-name' ~/.gtkrc-2.0; then
        sed -i 's/gtk-theme-name =.*/gtk-theme-name = "'"$1"'"/g' ~/.gtkrc-2.0
    else
        echo 'gtk-theme-name = "'"$1"'"' >>~/.gtkrc-2.0
    fi

}

# does gtk theme exist in any valid folder
themeexists() {
    if { gtkloop "$HOME/.themes" "$1" ||
        gtkloop '/usr/share/themes' "$1"; }; then
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

    gtk3settings
    if grep -q 'gtk-icon-theme-name' ~/.config/gtk-3.0/settings.ini; then
        sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name='"$1"'/g' ~/.config/gtk-3.0/settings.ini
    else
        echo "gtk-icon-theme-name=$1" >>~/.config/gtk-3.0/settings.ini
    fi

    if grep -q 'gtk-icon-theme-name' ~/.gtkrc-2.0; then
        sed -i 's/gtk-icon-theme-name =.*/gtk-icon-theme-name = "'"$1"'"/g' ~/.gtkrc-2.0
    else
        echo 'gtk-icon-theme-name = "'"$1"'"' >>~/.gtkrc-2.0
    fi

}

icons_exist() {
    if { gtkloop "$HOME/.icons" "$1" ||
        gtkloop '/usr/share/icons' "$1" ||
        gtkloop "$HOME/.local/share/icons" "$1"; }; then

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

gtkfont() {
    dconf write '/org/mate/desktop/interface/font-name' "'$1'"

    # check for / create gtk 3 settings
    gtk3settings
    # set gtk3 settings
    if grep -q 'gtk-font-name' ~/.config/gtk-3.0/settings.ini; then
        sed -i 's/gtk-font-name=.*/gtk-font-name='"$1"'/g' ~/.config/gtk-3.0/settings.ini
    else
        echo "gtk-font-name=$1" >>~/.config/gtk-3.0/settings.ini
    fi

    if grep -q 'gtk-font-name' ~/.gtkrc-2.0; then
        sed -i 's/gtk-font-name =.*/gtk-font-name = "'"$1"'"/g' ~/.gtkrc-2.0
    else
        echo 'gtk-font-name = "'"$1"'"' >>~/.gtkrc-2.0
    fi

}

gtkdocumentfont() {
    dconf write '/org/mate/desktop/interface/document-font-name' "'$1'"
}

setcursor() {
    mkdir -p ~/.icons/default &>/dev/null
    APPENDFILE=~/.icons/default/index.theme
    echo "# This file is written by pb-suckless. Do not edit." >$APPENDFILE
    app "[Icon Theme]"
    app "Name=Default"
    app "Comment=Default Cursor Theme"
    app "Inherits=$1"
}

rofitheme() {
    mkdir -p ~/.config/rofi &>/dev/null
    curl -s "https://raw.githubusercontent.com/paperbenni/dotfiles/master/rofi/$1.rasi" >~/.config/rofi/$1.rasi
    echo "rofi.theme: ~/.config/rofi/$1.rasi" >~/.config/rofi/config
}

dunsttheme() {
    [ -e ~/.config/dunst ] || mkdir -p ~/.config/dunst
    curl -s "https://raw.githubusercontent.com/paperbenni/dotfiles/master/dunstrc" >~/.config/dunst/dunstrc
    curl -s "https://raw.githubusercontent.com/paperbenni/dotfiles/master/dunst/$1" >>~/.config/dunst/dunstrc
}
