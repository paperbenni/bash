#!/usr/bin/env bash
pname hash/hash

different() {
    [ -e /tmp/pbdifferentfiles ] && rm /tmp/pbdifferentfiles

    for i in "$@"; do
        sha256sum "$i" | grep -o '.* ' >>/tmp/pbdifferentfiles
    done

    if sort -u /tmp/pbdifferentfiles | wc -l | grep -q '1'; then
        echo "files are identical"
        return 0
    else
        echo "files are different"
        return 1
    fi
}
