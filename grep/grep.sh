#!/usr/bin/env bash
pname grep/grep

regexfilter() {
    FILE="$1"
    shift 1
    for i in "$@"; do
        echo "processing filter $i"
        cat "$FILE" | egrep -v "$i" >"$FILE.1"
        rm "$FILE"
        mv "$FILE.1" "$FILE"
    done
}
