#!/usr/bin/env bash

if ! [ -z "$PAPERIMPORT" ]; then
    echo "paperbenni importer found"
    return 0
fi

if [ -e ~/.paperdebug ]; then
    echo "debugging mode enabled"
fi

PAPERENABLE="false"

pb() {
    case "$1" in
    clear)
        echo clearing the cache
        rm -rf ~/pb
        ;;
    help)
        echo "usage: pb filelocationonmygithubbashrepo"
        ;;
    nocache)
        echo "disabling cache"
        NOCACHE="true"
        ;;
    *)
        PAPERENABLE="true"
        if [ -z "$@" ]; then
            echo "usage: pb bashfile"
            return
        fi
        echo "importing $@"
        ;;
    esac

    if [ "$PAPERENABLE" = "false" ]; then
        echo "done, exiting"
        return 0
    fi

    for FILE in "$@"; do
        if ! [ -e ~/.paperdebug ]; then
            if ! [ -e "~/pb/$FILE" ] || [ -z "$NOCACHE" ]; then
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
