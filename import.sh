#!/usr/bin/env bash

pb() {
    case "$1" in
    clear)
        echo clearing the cache
        rm -rf ~/pb
        return
        ;;
    help)
        echo "usage: pb filelocationonmygithubbashrepo"
        return
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
            if echo "$FILE" | grep "/"; then
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

echo "paperbenni bash importer ready for use!"
