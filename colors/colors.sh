#!/usr/bin/env bash
pname colors/colors

# get all html color codes from file
getcolors() {
    grep -Eo '#[0-9a-fA-F]{6}' | sort -u
}
