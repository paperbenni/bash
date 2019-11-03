#!/usr/bin/env bash
pname wget/wget
pb wget/fakebrowser

# download all images from a single webpage
downloadimages() {
    fakebrowser "$1"
    wget -i $(egrep -o 'src=".*/.*\.jpg"' <index.html | egrep -o '".*"' | egrep -o '[^"]*')
    wget -i $(egrep -o 'src=".*/.*\.png"' <index.html | egrep -o '".*"' | egrep -o '[^"]*')
    rm index.html
}
