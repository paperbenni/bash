#!/bin/bash
# instantOS related utilities

pname instantos

instanttheme() {
    [ -n "$1" ] || return
    mkdir -p ~/instantos/themes &>/dev/null
    curl -s "https://raw.githubusercontent.com/instantOS/instant-THEMES/master/colors/$1.theme" > \
        ~/instantos/themes/"$1.theme"
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

instantforeground() {
    cat "$(getinstanttheme)" | grep 'foreground' | grep -Eo '.{7}$'
}

instantbackground() {
    cat "$(getinstanttheme)" | grep 'background' | grep -Eo '.{7}$'
}
