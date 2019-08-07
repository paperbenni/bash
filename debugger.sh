#!/usr/bin/env bash
papertest() {
    if [ -e ~/workspace/bash/import.sh ]; then
        source ~/workspace/bash/import.sh
    else
        source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
    fi
}
