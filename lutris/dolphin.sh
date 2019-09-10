#!/bin/bash

pname lutris/dolphin

# wrapper to execute sed command on dolphin config
changewii() {
    pushd ~/.config/dolphin-emu &>/dev/null
    sed -i "$1" Dolphin.ini
    popd &>/dev/null
}

# fixes an error when launching geckoOS from modern versions of dolphin
fixgecko() {
    pushd ~/.config/dolphin-emu &>/dev/null

    if ! grep 'MMU = False' <Dolphin.ini &>/dev/null; then
        changewii '/^\[Core\].*/a MMU = False'
    fi

    if ! grep 'UsePanicHandlers = False' <Dolphin.ini &>/dev/null; then
        changewii 's/UsePanicHandlers = True/UsePanicHandlers = False/g'
    fi

    popd &>/dev/null
}

# insert iso into dolphin disk slot
wiinsertiso() {
    if test -e "$1"; then
        ISOPATH2="$(realpath $1)"
    else
        ISOPATH2="$1"
    fi
    ISOPATH=${ISOPATH2//./\\.}
    changewii 's@DefaultISO = .*@DefaultISO = '"$ISOPATH"'@g'
}

# insert virtual sd card file into dolphin wii
wiinsertsd() {
    if test -e "$1"; then
        SDPATH2="$(realpath $1)"
    else
        SDPATH2="$1"
    fi
    SDPATH=${SDPATH2//./\\.}
    changewii 's@WiiSDCardPath = .*@WiiSDCardPath = '"$SDPATH"'@g'
}
