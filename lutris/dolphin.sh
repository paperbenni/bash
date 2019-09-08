#!/bin/bash

pname lutris/dolphin

# wrapper to execute sed command on dolphin config
changewii() {
    pushd ~/.config/dolphin-emu
    sed -i $1 Dolphin.ini
    popd
}

# fixes an error when launching geckoOS from modern versions of dolphin
fixgecko() {
    pushd ~/.config/dolphin-emu

    if grep 'MMU = False' <Dolphin.ini; then
        echo "MMU fix already applied"
    else
        changewii '/^\[Core\].*/a MMU = False'
    fi

    if grep 'UsePanicHandlers = False' <Dolphin.ini; then
        echo "panic handlers already disabled"
    else
        changewii 's/UsePanicHandlers = True/UsePanicHandlers = False/g'
    fi

    popd
}

# insert iso into dolphin disk slot
wiinsertiso() {
    exists "$1"
    echo "default iso set to $1"
    changewii 's~DefaultISO = .*~DefaultISO = '"$1"'~g'
}

# insert virtual sd card file into dolphin wii
wiinsertsd() {
    if exists "$1"; then
        SDPATH="$(realpath $1)"
    else
        SDPATH="$1"
    fi
    changewii 's~WiiSDCardPath = .*~WiiSDCardPath = '"$SDPATH"'~g'
}
