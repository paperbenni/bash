#!/usr/bin/env bash

########################
## paperbash importer ##
########################

if ! [ -e ~/paperbenni/import.sh ]; then
    mkdir ~/paperbenni
    curl https://raw.githubusercontent.com/paperbenni/bash/master/import.sh >~/paperbenni/import.sh
fi

if ! [ "${SHELL##*/}" == 'bash' ]; then
    if grep -iq 'alpine' </etc/os-release; then
        echo "it's alpine, you probably know what youre doing..."
    else
        echo "error: shell is not bash"
        return 0
    fi
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
            echo clearing the cache
            rm -rf ~/pb
            ;;
        help)
            echo "usage: pb [package name]"
            echo "you can find a list of available packages on my github"
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
                for i in $PPACKAGES; do
                    echo "source $i"
                    psource ~/workspace/bash/"$i.sh"
                done
            else
                cat ~/workspace/bash/"$2.sh" || (echo "debug package not found" && return 1)
                psource ~/workspace/bash/"$2.sh"
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
            cat ~/workspace/bash/"$PAPERPACKAGE" || { echo "debug package not found" && return 1; }
        fi
        if [ -e ~/workspace/bash/"$PAPERPACKAGE" ]; then
            psource ~/workspace/bash/"$PAPERPACKAGE"
        else
            echo "paperpackage $PAPERPACKAGE not found"
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
        echo "multi import statement"
        IFS2="$IFS"
        IFS=" "
        for i in "$@"; do
            # remove trailing and leading space
            PKGNAME=$(sed 's/^[ \t]*//;s/[ \t]*$//' <<<"$i")
            echo "importing $PKGNAME"
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
        if [ -n "$1" ]; then
            sleep "$1"
        else
            sleep 20
        fi
        rm ~/.papersilent
    } &
}

# silentable echo
pecho() {
    if [ -e ~/.papersilent ]; then
        return 0
    else
        echo "$@"
    fi
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

    # less wrapper ffor pblsraw
    pbls() {
        pblsraw | less
    }
fi
