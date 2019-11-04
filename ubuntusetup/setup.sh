#!/bin/bash
pname ubuntusetup/setup

# installs initial programs on a fresh ubuntu install
ubuntusetup() {
    pushd ~/
    sudo apt update
    sudo apt upgrade -y
    sudo apt update
    if [ -e .paperbenni/setup/programs.txt ]; then
        echo "program list found"
    else
        echo "no list found" >&2
        return 1
    fi

    for THISPROGRAM in $(< .paperbenni/setup/programs.txt); do
        sudo apt install -y $THISPROGRAM
    done
    popd
}
