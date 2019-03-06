#!/usr/bin/env bash

pb() {
    if [ -z "$@" ]; then
        echo "usage: pb bashfile"
    fi
    for FILE in "$@"; do
        curl "https://raw.githubusercontent.com/paperbenni/bash/master/bash/$1" >temp.sh
        source temp.sh
        rm temp.sh
    done
}
