#!/bin/bash

pname mpm/mpm

mpm() {
    # download if not already
    if ! [ -e ~/.cache/mpm/mpm.sh ]; then
        mkdir -p ~/.cache/mpm/
        curl -s 'https://raw.githubusercontent.com/paperbenni/mpm/master/mpm.sh' >~/.cache/mpm/mpm.sh
        chmod +x ~/.cache/mpm/mpm.sh
    fi

    ~/.cache/mpm/mpm.sh $@

}
