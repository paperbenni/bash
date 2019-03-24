#!/usr/bin/env bash

if ! [ -z "$PAPERIMPORT" ]; then
    echo "paperbenni importer found"
    return 0
fi

if [ -e ~/.paperdebug ]; then
    echo "debugging mode enabled"
fi

pb() {
    case "$1" in
    clear)
        echo clearing the cache
        rm -rf ~/pb
        return 0
        ;;
    help)
        echo "usage: pb filelocationonmygithubbashrepo"
        return 0
        ;;
    *)
        if [ -z "$@" ]; then
            echo "usage: pb bashfile"
            return
        fi
        echo "importing $@"
        ;;
    esac

    for FILE in "$@"; do
        if ! [ -e ~/.paperdebug ]; then
            if ! [ -e "~/pb/$FILE" ]; then
                if echo "$FILE" | grep -q "/"; then
                    FILEPATH=${FILE%/*}
                    mkdir -p ~/pb/"$FILEPATH"
                fi
                curl -s "https://raw.githubusercontent.com/paperbenni/bash/master/$FILE" >~/pb/"$FILE"
            else
                echo "using $FILE from cache"
            fi
            source ~/pb/"$FILE"
        else
            echo "using debugging version"
            source ~/workspace/bash/"$FILE"
        fi

    done
}

PAPERIMPORT="paperbenni.github.io/bash"

echo "paperbenni bash importer ready for use!"
