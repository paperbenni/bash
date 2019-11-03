#!/usr/bin/env bash
pname wget/wget
pb wget/fakebrowser

downloadformat() {
    if grep "$1" <index.html; then
        wget -i $(egrep -o 'src=".*/.*\.'"$1"'"' <index.html | egrep -o '".*"' | egrep -o '[^"]*')
    fi
}

# download all images from a single webpage
downloadimages() {
    fakebrowser "$1"
    downloadformat "jpg"
    downloadformat "png"
    downloadformat "jpeg"
    downloadformat "gif"
    rm index.html
}
