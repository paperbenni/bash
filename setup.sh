#!/usr/bin/env bash

cd
if ! command -v papertest; then
    touch .paperdebug
    echo "setting up pb development environment"
    curl https://raw.githubusercontent.com/paperbenni/bash/master/debugger.sh >papertest
    chmod +x papertest
    sudo mv papertest /usr/bin/
    echo "done setting up papertest"
    if ! grep 'pb()' <~/.bashrc; then
        echo 'pb(){ source $(which papertest) ; }' >>~/.bashrc
    fi
else
    rm .paperdebug
    sudo rm /usr/bin/papertest
    echo "done removing papertest"
    sed -i '/pb().*$/d' ~/.bashrc
fi
