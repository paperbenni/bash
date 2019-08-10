#!/usr/bin/env bash
if ! echo "$SHELL" | grep "bash"; then
    echo "only for bash"
    exit 1
fi

if [ -e ~/workspace/bash/import.sh ]; then
    source ~/workspace/bash/import.sh
else
    source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
fi
