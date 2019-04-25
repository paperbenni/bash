#!/usr/bin/env bash
pname colors/colors

getcolors() {
    egrep -o '#[0-9a-fA-F]{6}' | sort -u
}
