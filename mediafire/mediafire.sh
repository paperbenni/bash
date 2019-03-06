#!/bin/bash
urldecode() {
    : "${*//+/ }"
    echo -e "${_//%/\\x}"
}

mediafire() {

    (
        wget --version
        curl --version
        sed --version
        grep --version
    )
    
    LAST="$?"
    if ! [ "$LAST" = 0 ]; then
        echo "not all dependencies installed"
        exit
    fi

    if [ -z "$1" ]; then
        echo "usage: ./mediafiredownload.sh mediafirelink"
        sleep 5
        exit
    fi

    LINKLINE=$(curl "$1" | grep "http:\/\/download.*mediafire.com\/")
    NOPREFIX=${LINKLINE#*href=\"}
    NOSUFFIX=${NOPREFIX%\">}
    echo "$NOSUFFIX"
    clear
    FILENAME=$(urldecode ${NOSUFFIX##*/})

    echo "$FILENAME"
    sleep 2
    wget -O "$FILENAME" "$NOSUFFIX"

}
