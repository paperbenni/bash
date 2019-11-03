#!/usr/bin/env bash
pname wget/wget

# download all images from webpage
downloadimages() {
    wget -i $(curl "$1" | egrep -o 'src=".*/.*.jpg"' | egrep -o '".*"' | egrep -o '[^"]*')
}
