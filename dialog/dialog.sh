#!/usr/bin/env bash
#dialog confirm promt that returns exit status
confirm() {
    DIATEXT=${1:-are you sure about that?}
    dialog --yesno "$DIATEXT" 7 60
}

textbox() {
    DIATEXT=${1:-enter text}
    unset user_input
    while [ -z "$user_input" ]; do
        #statements
        user_input=$(
            dialog --inputbox "$DIATEXT" 8 40 \
                3>&1 1>&2 2>&3 3>&-
        )
    done
    echo "$user_input"
}

messagebox() {
    DIATEXT=${1:-Please accept}
    dialog --msgbox "$DIATEXT" 7 40
}