#!/usr/bin/env bash
pname hash/hash

different() {
    declare -i LINE_COUNT=0
    while read -a LINE; do
        LINE_COUNT+=1
        if [ $LINE_COUNT -eq 1 ]; then
            local HASH1=${LINE%% *}
        elif [ $LINE_COUNT -eq 2 ]; then
            local HASH2=${LINE%% *}

            # In-case more files are given by accident.
            break
        fi
    done < "$(sha256sum "$1" "$2" 2>&-)"

    if [ "$HASH1" == "$HASH2" ]; then
        echo "Files '$1' and '$2' are identical."
        return 1
    else
        echo "Files '$1' and '$2' differ."
    fi
}
