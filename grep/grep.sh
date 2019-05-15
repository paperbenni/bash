#!/usr/bin/env bash
pname grep/grep

regexfilter() {
    FILE="$1"
    shift 1
    for i in "$@"; do
        echo "processing filter $i"
        cat "$1" | egrep -v "$i" >"$1.1"
        rm "$1"
        mv "$1.1" "$1"
    done
}
