#!/usr/bin/env bash
pname dialog/dialog
#dialog confirm promt that returns exit status
confirm() {
    DIATEXT=${1:-are you sure about that?}
    dialog --yesno "$DIATEXT" 7 60
}

textbox() {
    unset user_input
    while [ -z "$user_input" ]; do
        #statements
        user_input=$(
            dialog --inputbox "${1:-enter text}" 8 40 \
                3>&1 1>&2 2>&3 3>&-
        )
    done
    echo "$user_input"
}

passwordbox() {
    unset user_input
    while [ -z "$user_input" ]; do
        #statements
        user_input=$(
            dialog --passwordbox "${1:-enter password}" 8 40 \
                3>&1 1>&2 2>&3 3>&-
        )
    done
    echo "$user_input"
}

messagebox() {
    DIATEXT=${1:-Please accept}
    dialog --msgbox "$DIATEXT" 7 40
}
