#!/usr/bin/env bash
pname grep/grep

regexfilter() {
    FILE="$1"
    shift 1
    for i in "$@"; do
        echo "processing filter $i"
        egrep -v "$i" <"$FILE" >"$FILE.1"
        rm "$FILE"
        mv "$FILE.1" "$FILE"
    done
}

betweenquotes() {
    QUOTE=${2:-\"}
    egrep -o "$QUOTE"'[^,]*'"$QUOTE" | egrep -o "[^$QUOTE]*"
}
