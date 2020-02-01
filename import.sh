#!/usr/bin/env bash

########################
## paperbash importer ##
########################

# silentable echo
pecho() {
    if [ -e ~/.papersilent ] || [ -n "$PAPERSILENT" ]; then
        return 0
    else
        echo "$@"
    fi
}

if ! [ "${SHELL##*/}" == 'bash' ] && ! [ -e ~/.paperforce ]; then
    pecho "error: shell is not bash"
    return 0
fi

if ! [ "$0" = "bash" ]; then
    SCRIPTPATH="$(
        cd "$(dirname "$0")" >/dev/null 2>&1
        pwd -P
    )"
fi

if [ -n "$SCRIPTPATH" ] &&
    [ -e "$SCRIPTPATH/install" ] &&
    [ -e "$SCRIPTPATH/titlesite" ]; then
    OFFLINEINSTALL=true
fi

# pb already sourced?
if [ -z "$PAPERIMPORT" ]; then
    PAPERIMPORT="paperbenni.github.io/bash"
else
    pecho "paperbenni importer found"
    return 0
fi

[ -e ~/.paperdebug ] && pecho "debugging mode enabled"

# default fetching url
PAPERGIT="https://raw.githubusercontent.com/paperbenni/bash/master"

# turn argument into proper pb package name
pbname() {
    if [[ "$1" == *.* ]]; then
        if [[ "$1" == */* ]]; then
            if [[ "$1" == *.sh* ]]; then
                echo "$1"
            else
                echo "${1//.//}.sh"
            fi
        else
            if [[ "$1" == *.sh* ]]; then
                echo "${1%.sh}/$1"
            else
                echo "${1//.//}.sh"
            fi
        fi

    else
        if [[ "$1" == */* ]]; then
            echo "$1.sh"
        else
            echo "$1/$1.sh"
        fi
    fi
}

# raw import function
pbimport() {
    {
        PAPERENABLE="false"
        case "$1" in
        clear)
            pecho clearing the cache
            rm -rf ~/pb
            ;;
        help)
            pecho "usage: pb [package name]"
            pecho "you can find a list of available packages on my github"
            ;;
        nocache)
            pecho "disabling cache"
            NOCACHE="true"
            ;;
        list)
            pecho "imported packages:"
            pecho "$PAPERLIST"
            ;;
        *)
            PAPERENABLE="true"
            if [ -z "$@" ]; then
                pecho "usage: pb bashfile"
                return 0
            fi
            ;;
        esac
    }

    [ "$PAPERENABLE" = "false" ] && return 0

    PAPERPACKAGE=$(pbname "$1")
    pecho "$PAPERPACKAGE"

    # only import once
    if grep -q "$PAPERPACKAGE" <<<"$PAPERLIST"; then
        pecho "$1 already imported"
        return 0
    fi

    if [ -e ~/.paperdebug ]; then
        psource ~/workspace/bash/$PAPERPACKAGE
    elif [ -n "$OFFLINEINSTALL" ]; then
        psource $SCRIPTPATH/$PAPERPACKAGE
    else
        curl -s "$PAPERGIT/$PAPERPACKAGE" >/tmp/papercache
        psource /tmp/papercache
        rm /tmp/papercache
    fi
}

# source or list functions
psource() {
    [ -e "$1" ] || return 1
    if [ -n "$PAPERDOC" ]; then
        unset PAPERDOC
        cat "$1" | egrep -o '^.*\(\).*{' | grep -o '^[^(]*'
    else
        source "$1"
    fi
}

# main importer function
pb() {
    # process multiple packages
    if [ -n "$2" ]; then
        pecho "multi import statement"
        IFS2="$IFS"
        IFS=" "
        for i in "$@"; do
            # remove trailing and leading space
            PKGNAME=$(sed 's/^[ \t]*//;s/[ \t]*$//' <<<"$i")
            pecho "importing $PKGNAME"
            pbimport "$PKGNAME"
        done
        IFS="$IFS2"
        return

    else
        PKGNAME=$(sed 's/^[ \t]*//;s/[ \t]*$//' <<<"$1")
        pbimport "$PKGNAME"
    fi
}

# set package name inside function script
pname() {
    PAPERLIST="$PAPERLIST $(pbname $1)\n"
}

psilent() {
    {
        touch ~/.papersilent
        export PAPERSILENT="true"
        if [ -n "$1" ]; then
            sleep "$1"
        else
            sleep 20
        fi
        unset PAPERSILENT
        rm ~/.papersilent
    } &
}

# list package functions
pdoc() {
    PAPERDOC="True"
    pb $@
}

pb bash

# functions only available in debug mode
if [ -e ~/.paperdebug ]; then

    # list all packages in pretty format
    pblsraw() {
        (
            cd ~/workspace/bash
            for i in ./*; do
                if ! [ -d "$i" ]; then
                    continue
                fi
                echo "${i#./}"
                cd "$i"
                for sh in ./*.sh; do
                    echo "#### ${sh#./}"
                done
                echo ".."
                cd ..
            done
        )
    }

    # grep the repo
    pbgrep() {
        (
            cd ~/workspace/bash
            git grep $@ | less
        )
    }

    # less wrapper for pblsraw
    pbls() {
        pblsraw | less
    }
fi
