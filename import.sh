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

if ! [ -e ~/paperbenni/import.sh ]; then
    # cache import script
    pecho "caching import script"
    mkdir ~/paperbenni &>/dev/null
    curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh >~/paperbenni/import.sh
fi

if ! [ "${SHELL##*/}" == 'bash' ]; then
    if grep -iq 'alpine' </etc/os-release; then
        pecho "it's alpine, you probably know what youre doing..."
    else
        pecho "error: shell is not bash"
        return 0
    fi
fi

# pb already sourced?
if [ -z "$PAPERIMPORT" ]; then
    PAPERIMPORT="paperbenni.github.io/bash"
    pecho "paperbenni bash importer ready for use!"
else
    pecho "paperbenni importer found"
    return 0
fi

if [ -e ~/.paperdebug ]; then
    pecho "debugging mode enabled"
fi

# default fetching url
PAPERGIT="https://raw.githubusercontent.com/paperbenni/bash/master"

# turn argument into proper pb package name
pbname() {
    if [[ "$1" == *.* ]]; then
        if [[ "$1" == */* ]]; then
            if [[ "$1" == *.sh* ]]; then
                pecho "$1"
            else
                pecho "${1//.//}.sh"
            fi
        else
            if [[ "$1" == *.sh* ]]; then
                pecho "${1%.sh}/$1"
            else
                pecho "${1//.//}.sh"
            fi
        fi

    else
        if [[ "$1" == */* ]]; then
            pecho "$1.sh"
        else
            pecho "$1/$1.sh"
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
        debug)
            if [ "$2" = "all" ]; then
                PPACKAGES="$(pecho "$PAPERLIST" | egrep -o '[^ :]*')"
                pecho "refreshing $PPACKAGES"
                for i in $PPACKAGES; do
                    pecho "source $i"
                    psource ~/workspace/bash/"$i.sh"
                done
            else
                cat ~/workspace/bash/"$2.sh" || (pecho "debug package not found" && return 1)
                psource ~/workspace/bash/"$2.sh"
            fi
            return 0
            ;;
        offupdate)
            pecho "updating offline install"
            cd
            cd workspace
            rm -rf bash
            git clone --depth=1 https://github.com/paperbenni/bash.git
            ;;
        *)
            PAPERENABLE="true"
            if [ -z "$@" ]; then
                pecho "usage: pb bashfile"
                return 0
            fi
            pecho "importing $@"
            ;;
        esac
    }

    if [ "$PAPERENABLE" = "false" ]; then
        pecho "done, exiting"
        return 0
    fi

    PAPERPACKAGE=$(pbname "$1")
    pecho "$PAPERPACKAGE"

    # only import once
    if grep -q "$PAPERPACKAGE" <<<"$PAPERLIST"; then
        pecho "$1 already imported"
        return 0
    fi

    if ! [ -e ~/.paperdebug ]; then
        if ! [ -e "~/pb/$PAPERPACKAGE" ] || [ -z "$NOCACHE" ]; then
            if grep -q "/" <<<"$PAPERPACKAGE"; then
                FILEPATH=${PAPERPACKAGE%/*}
                mkdir -p ~/pb/"$FILEPATH"
            fi

            curl -s "$PAPERGIT/$PAPERPACKAGE" >~/pb/"$PAPERPACKAGE"
        else
            pecho "using $PAPERPACKAGE from cache"
        fi

        if grep -q 'pname' <~/pb/"$PAPERPACKAGE"; then
            pecho "script is valid"
            psource ~/pb/"$PAPERPACKAGE"
        else
            pecho "$PAPERPACKAGE not a pb package"
        fi
    else
        pecho "using debugging version"
        if ! [ -e ~/.papersilent ]; then
            cat ~/workspace/bash/"$PAPERPACKAGE" || { pecho "debug package not found" && return 1; }
        fi
        if [ -e ~/workspace/bash/"$PAPERPACKAGE" ]; then
            psource ~/workspace/bash/"$PAPERPACKAGE"
        else
            pecho "paperpackage $PAPERPACKAGE not found"
        fi
    fi

}

# source or list functions
psource() {
    if [ -n "$PAPERSOURCE" ]; then
        grep '.*().*\{' <"$1" | less
        unset PAPERSOURCE
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
    PAPERSOURCE="True"
    pb $@
}

SCRIPTDIR=$(grep -o '.*/' <<<"$0")
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
                pecho "${i#./}"
                cd "$i"
                for sh in ./*.sh; do
                    pecho "#### ${sh#./}"
                done
                pecho ".."
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
