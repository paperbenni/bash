#!/usr/bin/env bash
getcolors() {
    egrep -o '#[0-9a-fA-F]{6}' | sort -u
}
