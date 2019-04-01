#!/bin/bash

#decodes html encoded strings
urldecode() {
    : "${*//+/ }"
    echo -e "${_//%/\\x}"
}

mediafire() {

    (
        command -v wget
        command -v curl
        command -v sed
        command -v grep
    ) &>/dev/null

    LAST="$?"
    if ! [ "$LAST" = 0 ]; then
        echo "not all dependencies installed"
        return
    fi

    if [ -z "$1" ]; then
        echo "usage: ./mediafiredownload.sh mediafirelink"
        sleep 5
        return
    fi

    LINKLINE=$(curl -s "$1" | grep "http:\/\/download.*mediafire.com\/")
    NOPREFIX=${LINKLINE#*href=\"}
    NOSUFFIX=${NOPREFIX%\">}
    echo "$NOSUFFIX"
    FILENAME=$(urldecode ${NOSUFFIX##*/})

    sleep 2
    wget -O "$FILENAME" "$NOSUFFIX" -q --show-progress

}
