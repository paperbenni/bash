#!/usr/bin/env bash
pname hash/hash

different() {
    HASH1=$(sha256sum $1 | awk '{ print $1 }')
    HASH2=$(sha256sum $2 | awk '{ print $1 }')
    if [ "$HASH1" = "$HASH2" ]; then
        echo "files $1 and $2 are identical"
        return 1
    else
        return 0
        echo "files $1 and $2 differ"
    fi

}
