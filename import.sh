#!/usr/bin/env bash

if ! [ -z "$PAPERIMPORT" ]; then
    echo "paperbenni importer found"
    return 0
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
        echo "importing $@"
        ;;
    esac

    if [ -z "$@" ]; then
        echo "usage: pb bashfile"
    fi

    for FILE in "$@"; do
        if ! [ -e "~/pb/$FILE" ]; then
            if echo "$FILE" | grep "/" >/dev/null; then
                FILEPATH=${FILE%/*}
                mkdir -p ~/pb/"$FILEPATH"
            fi
            curl -s "https://raw.githubusercontent.com/paperbenni/bash/master/$FILE" >~/pb/"$FILE"
        else
            echo "using $FILE from cache"
        fi
        source ~/pb/"$FILE"

    done
}

PAPERIMPORT="paperbenni.github.io/bash"

echo "paperbenni bash importer ready for use!"
