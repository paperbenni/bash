#!/bin/bash
pname gtk/gtk

DOTRAW="https://raw.githubusercontent.com/instantos/dotfiles/master"
THEMERAW="https://raw.githubusercontent.com/instantos/instantthemes/master"

### general utilities ###

# initializes gtk3 config files
gtk3settings() {
    if ! [ -e ~/.config/gtk-3.0/settings.ini ]; then
        mkdir -p ~/.config/gtk-3.0
        echo "[Settings]" >~/.config/gtk-3.0/settings.ini
    fi
}

# checks if either a theme or icon set exists in folder $1
gtkloop() {
    pushd . &>/dev/null
    cd "$1" || exit
    echo "$1"
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
    gtk3settings
    # set gtk3 settings
    if [ -e ~/.config/gtk-3.0/settings.ini ] && grep -q 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini; then
        if grep -q "gtk-theme-name=$1$" ~/.config/gtk-3.0/settings.ini; then
            echo "gtk theme already applied"
            return
        else
            sed -i 's/gtk-theme-name=.*/gtk-theme-name='"$1"'/g' ~/.config/gtk-3.0/settings.ini
        fi
    else
        echo "gtk-theme-name=$1" >>~/.config/gtk-3.0/settings.ini
    fi

    if [ -e ~/.gtkrc-2.0 ] && grep -q 'gtk-theme-name' ~/.gtkrc-2.0; then
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

    if [ -e ~/.config/qt5ct/qt5ct.conf ]; then
        if grep -q "icon_theme=$1$" ~/.config/qt5ct/qt5ct.conf; then
            echo "qt icons already applied"
        else
            sed -i 's/icon_theme=.*/icon_theme='"$1"'/g' ~/.config/qt5ct/qt5ct.conf
        fi
    fi

    gtk3settings
    if grep -q 'gtk-icon-theme-name' ~/.config/gtk-3.0/settings.ini; then
        if grep -q "gtk-icon-theme-name=$1$" ~/.config/gtk-3.0/settings.ini; then
            echo "gtk icons already applied"
        else
            sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name='"$1"'/g' ~/.config/gtk-3.0/settings.ini
        fi
    else
        echo "gtk-icon-theme-name=$1" >>~/.config/gtk-3.0/settings.ini
    fi

    if grep -q 'gtk-icon-theme-name' ~/.gtkrc-2.0; then
        if grep -q 'gtk-icon-theme-name = "'"$1"'"$' ~/.gtkrc-2.0; then
            echo "gtk2 theme already applied"
        else
            sed -i 's/gtk-icon-theme-name =.*/gtk-icon-theme-name = "'"$1"'"/g' ~/.gtkrc-2.0
        fi
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

listtermfonts() {
    fc-list -f "%{family} : %{file}\n" :spacing=100 | sort | less
}

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
    [ -n "$2" ] && fontexists "$2" && return 0

    if [ -e ~/.local/share/fonts/"${1##*/}" ]; then
        echo "font file conflict"
        return 1
    fi
    mv "$1" ~/.local/share/fonts/
    echo "installed font $1"
}

gtkfont() {

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

# install cursor from github
papercursor() {
    echo "fetching paper cursor"
    if ! [ -e ~/.icons/"$1" ]; then
        mkdir ~/.icons &>/dev/null
        cd ~/.icons || exit
        svn export "https://github.com/paperbenni/cursors.git/trunk/$1"
    fi
}

# set cursor in gtk and xorg
setcursor() {
    echo "setting cursors to $1"
    mkdir -p ~/.icons/default &>/dev/null
    APPENDFILE=~/.icons/default/index.theme
    echo "# This file is written by instantthemes. Do not edit." >$APPENDFILE
    app "[Icon Theme]"
    app "Name=Default"
    app "Comment=Default Cursor Theme"
    app "Inherits=$1"

    if [ -e ~/.Xresources ]; then
        if grep -q 'Xcursor.theme: ' ~/.Xresources; then
            sed -i 's/Xcursor.theme: .*/Xcursor.theme: '"$1"'/g'
        else
            # newline is needed because its missing in the default Xresources
            echo "\nXcursor.theme: $1" >>~/.Xresources
        fi
    fi
}

# copies a rofi theme config
rofitheme() {
    echo "Setting rofi theme to $1"
    mkdir -p ~/.config/rofi &>/dev/null
    if [ -e /usr/share/instantdotfiles/rofi/"$1".rasi ]; then
        cp /usr/share/instantdotfiles/rofi/"$1".rasi ~/.config/rofi/"$1".rasi
    else
        curl -s "$DOTRAW/rofi/$1.rasi" >~/.config/rofi/"$1".rasi
    fi

    echo "configuration {" >~/.config/rofi/config.rasi
    echo "theme: \"~/.config/rofi/$1.rasi\";" >>~/.config/rofi/config.rasi
    echo "}" >>~/.config/rofi/config.rasi

}

# download regular dunstrc and append color config
dunsttheme() {
    echo "setting dunst theme to $1"
    [ -e ~/.config/dunst ] || mkdir -p ~/.config/dunst
    if [ -e /usr/share/instantdotfiles/dunstrc ]; then
        cat /usr/share/instantdotfiles/dunstrc >~/.config/dunst/dunstrc
        cat /usr/share/instantthemes/dunst/"$1" >>~/.config/dunst/dunstrc
    else
        echo "falling back to online dunst theme"
        curl -s "$DOTRAW/dunstrc" >~/.config/dunst/dunstrc
        curl -s "$THEMERAW/dunst/$1" >>~/.config/dunst/dunstrc
    fi
}

# set up xresources
xtheme() {
    echo "Setting xorg theme to $1"
    if [ -e /usr/share/instantthemes ] && [ -e /usr/share/instantdotfiles ]; then
        cat /usr/share/instantthemes/xresources/"$1" >~/.Xresources
        cat /usr/share/instantdotfiles/Xresources >>~/.Xresources
    else
        curl -s "$THEMERAW/xresources/$1" >~/.Xresources
        curl -s "$DOTRAW/Xresources" >>~/.Xresources
        echo "please install instantthemes and instantdotfiles"
    fi
}

