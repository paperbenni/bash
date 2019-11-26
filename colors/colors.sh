#!/usr/bin/env bash
pname colors/colors

getcolors() {
    grep -Eo '#[0-9a-fA-F]{6}' | sort -u
}
