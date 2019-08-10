#!/usr/bin/env bash

cd
if ! command -v papertest; then
    touch .paperdebug
    echo "setting up pb development environment"
    curl https://raw.githubusercontent.com/paperbenni/bash/master/debugger.sh >papertest
    chmod +x papertest
    sudo mv papertest /usr/bin/
    echo "done setting up papertest"
else
    rm .paperdebug
    sudo rm /usr/bin/papertest
    echo "done removing papertest"
fi
