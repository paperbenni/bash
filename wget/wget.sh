#!/usr/bin/env bash
pname wget/wget
pb wget/fakebrowser

downloadformat() {
    if grep "$1" <index.html; then
        INDEX="${2:-index.html}"
        wget -i $(egrep -o 'src=".*/.*\.'"$1"'"' <index.html | egrep -o '".*"' | egrep -o '[^"]*')
    fi
}

# download all images from a single webpage
downloadimages() {
    mkdir .imagecache
    cd .imagecache
    fakebrowser "$1"
    SINDEX="$(ls)"
    downloadformat "jpg" "$SINDEX"
    downloadformat "png" "$SINDEX"
    downloadformat "jpeg" "$SINDEX"
    downloadformat "gif" "$SINDEX"
    rm "$SINDEX"
    mv ./* ../
    cd ..
    rm -r .imagecache
}
