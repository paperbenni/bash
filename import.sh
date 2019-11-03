#!/usr/bin/env bash
if ! [ "${SHELL##*/}" == 'bash' ]; then
    echo "error: shell is not bash"
    return 0
fi

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
        offupdate)
            echo "updating offline install"
            cd
            cd workspace
            rm -rf bash
            git clone --depth=1 https://github.com/paperbenni/bash.git
            ;;
        *)
            PAPERENABLE="true"
            if [ -z "$@" ]; then
                echo "usage: pb bashfile"
                return 0
            fi
            pecho "importing $@"
            ;;
    esac

    if [ "$PAPERENABLE" = "false" ]; then
        pecho "done, exiting"
        return 0
    fi

    PAPERPACKAGE="$1"
    if ! grep -q '/' <<< "$PAPERPACKAGE"; then
        PAPERPACKAGE="$PAPERPACKAGE/$PAPERPACKAGE"
    fi
    if ! grep -q '\.sh' <<< "$PAPERPACKAGE"; then
        PAPERPACKAGE="$PAPERPACKAGE.sh"
    fi
    pecho "$PAPERPACKAGE"
    if grep "${PAPERPACKAGE%.sh} " <<< "$PAPERLIST"; then
        pecho "$1 already imported"
        return 0
    fi

    if ! [ -e ~/.paperdebug ]; then
        if ! [ -e "~/pb/$PAPERPACKAGE" ] || [ -z "$NOCACHE" ]; then
            if grep -q "/" <<< "$PAPERPACKAGE"; then
                FILEPATH=${PAPERPACKAGE%/*}
                mkdir -p ~/pb/"$FILEPATH"
            fi
            curl -s "https://raw.githubusercontent.com/paperbenni/bash/master/$PAPERPACKAGE" >~/pb/"$PAPERPACKAGE"
        else
            pecho "using $PAPERPACKAGE from cache"
        fi

        if grep 'pname' <~/pb/"$PAPERPACKAGE"; then
            pecho "script is valid"
            source ~/pb/"$PAPERPACKAGE"
        else
            pecho "$PAPERPACKAGE not a pb package"
        fi
    else
        pecho "using debugging version"
        if ! [ -e ~/.papersilent ]; then
            cat ~/workspace/bash/"$PAPERPACKAGE" || { echo "debug package not found" && return 1; }
        fi
        source ~/workspace/bash/"$PAPERPACKAGE"
    fi

}

pname() {
    PAPERLIST="$PAPERLIST $1 "$'\n'
}

psilent() {
    {
        touch ~/.papersilent
        if [ -n "$1" ]; then
            sleep "$1"
        else
            sleep 20
        fi
        rm ~/.papersilent
    } &
}

pecho() {
    if [ -e ~/.papersilent ]; then
        return 0
    else
        echo "$@"
    fi
}

getdistro() {
    grep "NAME" /etc/os-release | egrep -o '".*"'
}

SCRIPTDIR=$(egrep -o '.*/' <<< "$0")
pb bash
