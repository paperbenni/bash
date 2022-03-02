#!/bin/bash
# instantOS related utilities

pname instantos

instanttheme() {
    [ -n "$1" ] || return
    mkdir -p ~/instantos/themes &>/dev/null
    if [ -e /usr/share/instantthemes ]; then
        cat /usr/share/instantthemes/colors/$1.theme >~/instantos/themes/"$1.theme"
    else
        curl -s "https://raw.githubusercontent.com/instantOS/instant-THEMES/master/colors/$1.theme" > \
            ~/instantos/themes/"$1.theme"
    fi
    echo "$1" >~/instantos/themes/config
}

instantthemecheck() {
    if ! [ -e ~/instantos/themes/config ]; then
        instanttheme dracula
    fi
}

getinstanttheme() {
    instantthemecheck
    cat ~/instantos/themes/config
}

# rgb foreground color
instantforeground() {
    instantthemes query colors.accent
}

# rgb background color
instantbackground() {
    instantthemes query colors.background
}
