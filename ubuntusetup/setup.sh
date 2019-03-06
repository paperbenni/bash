#!/bin/bash
papersetup() {
    pushd ~/
    sudo apt update
    sudo apt upgrade -y
    sudo apt update
    if [ -e .paperbenni/setup/programs.txt ]
    then
      echo "program list found"
    else
      echo "no list found"
      exit 1
    fi

    for THISPROGRAM in $(cat .paperbenni/setup/programs.txt)
    do
      sudo apt install -y $THISPROGRAM
    done
    popd
}
