#!/usr/bin/env bash

mvformat() {
    test -n "$1" || return 1
    for i in ./*; do
        NAME=$(echo $i | egrep -o '.*\.')
        mv "$i" "$NAME$1"
    done
}
