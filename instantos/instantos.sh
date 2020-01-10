#!/bin/bash
# instant-OS related utilities

pname instantos

instanttheme() {
    [ -n "$1" ] || return
    mkdir -p ~/instant-os/themes &>/dev/null
    curl -s "https://raw.githubusercontent.com/instant-OS/instant-THEMES/master/colors/$1.theme" > \
        ~/instant-os/themes/"$1.theme"
    echo "$1" >~/instant-os/themes/config
}

instantthemecheck() {
    if ! [ -e ~/instant-os/themes/config ]; then
        instanttheme dracula
    fi
}

getinstanttheme() {
    instantthemecheck
    cat ~/instant-os/themes/config
}

instantforeground() {
    cat "$(getinstanttheme)" | grep 'foreground' | grep -Eo '.{7}$'
}

instantbackground() {
    cat "$(getinstanttheme)" | grep 'background' | grep -Eo '.{7}$'
}
