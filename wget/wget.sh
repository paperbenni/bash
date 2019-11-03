#!/usr/bin/env bash
pname wget/wget

# download all images from a single webpage
downloadimages() {
    wget -i $(curl "$1" | egrep -o 'src=".*/.*\.jpg"' | egrep -o '".*"' | egrep -o '[^"]*')
}
