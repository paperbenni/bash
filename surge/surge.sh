#!/bin/bash

#upload the current folder to a surge.sh site
surgesh() {
    echo "running surge.sh"
    if [ -z "$1" ]; then
        if ! [ -e surge.txt ]; then
            echo "surge.txt not found"
            exit
        else
            SURGE=$(cat surge.txt)
        fi
    else
        SURGE="$1"
    fi

    if ! surge --version; then
        curl https://raw.githubusercontent.com/paperbenni/bash/master/bash/install/install.sh >temp.sh
        source temp.sh
        rm temp.sh
        pinstall npm nodejs
    fi
    surge . "$SURGE".surge.sh
}
