#!/usr/bin/env bash

# pb already sourced?
if [ -z "$PAPERIMPORT" ]; then
    PAPERIMPORT="paperbenni.github.io/bash"
    echo "paperbenni bash importer ready for use!"
else
    echo "paperbenni importer found"
    return 0
fi

if [ -e ~/.paperdebug ]; then
    echo "debugging mode enabled"
fi

# imports bash functions from paperbenni/bash into the script
PAPERGIT="https://raw.githubusercontent.com/paperbenni/bash/master"

pb() {

    PAPERENABLE="false"
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
    list)
        echo "imported packages:"
        echo "$PAPERLIST"
        ;;
    debug)
        if [ "$2" = "all" ]; then
            PPACKAGES="$(echo "$PAPERLIST" | egrep -o '[^ :]*')"
            echo "refreshing $PPACKAGES"
            for i in "$PPACKAGES"; do
                echo "source $i"
                source ~/workspace/bash/"$i.sh"
            done
        else
            cat ~/workspace/bash/"$2.sh" || (echo "debug package not found" && return 1)
            source ~/workspace/bash/"$2.sh"
        fi
        return 0
        ;;
    *)
        PAPERENABLE="true"
        if [ -z "$@" ]; then
            echo "usage: pb bashfile"
            return 0
        fi
        echo "importing $@"
        ;;
    esac

    if [ "$PAPERENABLE" = "false" ]; then
        echo "done, exiting"
        return 0
    fi

    PAPERPACKAGE="$1"
    if ! echo "$PAPERPACKAGE" | grep '/'; then
        PAPERPACKAGE="$PAPERPACKAGE/$PAPERPACKAGE"
    fi
    if ! echo "$PAPERPACKAGE" | grep '\.sh'; then
        PAPERPACKAGE="$PAPERPACKAGE.sh"
    fi
    echo "$PAPERPACKAGE"
    if echo "$PAPERLIST" | grep "${PAPERPACKAGE%.sh} "; then
        echo "$1 already imported"
        return 0
    fi

    if ! [ -e ~/.paperdebug ]; then
        if ! [ -e "~/pb/$PAPERPACKAGE" ] || [ -z "$NOCACHE" ]; then
            if echo "$PAPERPACKAGE" | grep -q "/"; then
                FILEPATH=${PAPERPACKAGE%/*}
                mkdir -p ~/pb/"$FILEPATH"
            fi
            curl -s "https://raw.githubusercontent.com/paperbenni/bash/master/$PAPERPACKAGE" >~/pb/"$PAPERPACKAGE"
        else
            echo "using $PAPERPACKAGE from cache"
        fi

        if grep 'pname' < ~/pb/"$PAPERPACKAGE"; then
            echo "script is valid"
            source ~/pb/"$PAPERPACKAGE"
        else
            echo "$PAPERPACKAGE not a pb package"
        fi
    else
        echo "using debugging version"
        cat ~/workspace/bash/"$PAPERPACKAGE" || (echo "debug package not found" && return 1)
        source ~/workspace/bash/"$PAPERPACKAGE"
    fi

}

pname() {
    PAPERLIST="$PAPERLIST $1 "$'\n'
}

pb bash
