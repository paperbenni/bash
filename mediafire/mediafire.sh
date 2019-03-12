#!/bin/bash
urldecode() {
    : "${*//+/ }"
    echo -e "${_//%/\\x}"
}

mediafire() {

    (
        wget --version > /dev/null
        curl --version > /dev/null
        sed --version > /dev/null
        grep --version > /dev/null
    )

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

    LINKLINE=$(curl "$1" | grep "http:\/\/download.*mediafire.com\/")
    NOPREFIX=${LINKLINE#*href=\"}
    NOSUFFIX=${NOPREFIX%\">}
    echo "$NOSUFFIX"
    FILENAME=$(urldecode ${NOSUFFIX##*/})

    echo "$FILENAME"
    sleep 2
    wget -O "$FILENAME" "$NOSUFFIX" -q --show-progress

}
