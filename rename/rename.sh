#!/usr/bin/env bash

mvformat() {
    [ "$#" -eq 1 ] || return 1
    for i in *; do
        mv "$i" "${i%.*}.$1"
    done
}
