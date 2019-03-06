#!/bin/bash
lutrisinstall() {
    ver=$(lsb_release -sr)
    if [ $ver != "18.04" -a $ver != "17.10" -a $ver != "17.04" -a $ver != "16.04" ]; then ver=18.04; fi
    echo "deb http://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list
    wget -q http://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/Release.key -O- | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install lutris
}
