#!/usr/bin/env bash
pname cloudpie/cloudpie

#edits an option in retroarch.cfg
function changeconf() {
    if [ -z "$2" ]; then
        echo "usage: changeconf option value"
    fi
    if [ -z "$3" ]; then
        if ! [ -e ~/.config/retroarch/retroarch.cfg ]; then
            echo "generating config"
            timeout 5 retroarch
        fi
        pushd ~/.config/retroarch
        NEWVALUE="$1 = \"$2\""
        sed -i "/^$1 =/c $NEWVALUE" retroarch.cfg
        popd
    fi

}

# downloads a cloudpie file from github
function cget() {
    if [ -z "$1" ]; then
        echo "usage: cget filename"
    else
        for file in "$@"; do
            wget https://raw.githubusercontent.com/paperbenni/CloudPie/master/"$file"
        done
    fi
}

function retroupdate() {
    rm -rf ~/retroarch/"$1"
    mkdir -p ~/retroarch/"$1"
    pushd ~/retroarch/"$1"
    wget "$2" -q --show-progress
    unzip -o *.zip
    rm *.zip
    popd
}

#opens $2 with the specified libretro core
function retro() {
    retroarch -L "$HOME/retroarch/cores/$1.so" "$2"
}

# automatically determines rom type and opens the rom
function openrom() {
    pb grep
    if [ -z "$@" ]; then
        echo "usage: openrom filename console"
    fi
    if ! [ -e "$1" ]; then
        echo "file $1 not found"
        return 1
    fi
    if [ -n "$2" ]; then
        CONSOLE="$2"
    else
        echo "auto detecting rom"
        CONSOLE2="$(currentdir)"
        if [ -e ~/cloudpie/consoles/$CONSOLE2.conf ]; then
            CONESOLE="$(currentdir)"
        else
            echo "console $CONSOLE2 not found"
            return 1
        fi
    fi
    CORE="$(cat ~/cloudpie/consoles/$CONESOLE.conf | grep 'core' | betweenquotes)_libretro.so"
    retro "$CORE" "$1"
}

function repoload() {
    # $1 is the link
    # $2 is the repo file name
    # $3 is the system name
    # $4 is the file extension
    test -e ~/cloudpie/repos || mkdir -p ~/cloudpie/repos
    pb wget/curl
    echo "updating $1 repos"
    sleep 1
    getlinks "$1" >~/cloudpie/repos/"$2.txt"
    debug "$1"
    # add the link prefix as the last line
    echo "$1" >>~/cloudpie/repos/"$2".txt
}

function romupdate() {
    pb grep
    pushd ~/
    cd cloudpie/consoles || return 1
    for i in *; do
        if ! echo "$i" | grep '\.conf'; then
            echo "$i not a console, skipping"
            continue
        fi
        if ! cat "$i" | grep 'link'; then
            echo "no link for $i, skipping"
        fi
        RCONSOLE="${i%.*}"
        echo "repos for $RCONSOLE"
        getconsole "$RCONSOLE" link >repolink.txt
        REPOLINK="$(cat repolink.txt)"
        if ! echo "$REPOLINK" | grep 'http'; then
            LINK="https://the-eye.eu/public/rom/$REPOLINK/"
        else
            LINK="$REPOLINK"
        fi
        echo "link $LINK"
        repoload "$LINK" "$RCONSOLE"
    done

    popd
}

cloudconnect() {
    if ! [ -e "$HOME/cloudpie/save/cloud.txt" ]; then
        if ! [ -e "$HOME/cloudpie/sync.sh" ]; then
            echo "sync.sh missing"
            echo "your installation might be corrupted"
        fi

        echo "no existing connection found"
        ~/cloudpie/sync.sh &
        sleep 5
        mkdir -p ~/cloudpie/save/ &>/dev/null
        while ! cat ~/cloudpie/save/cloud.txt; do
            if ! pgrep dmenu; then
                echo "waiting for cloud saves"
            fi
            sleep 5
        done
    else
        echo "cloudpie already connected"
    fi
}

getconsole() {
    if ! [ -n "$2" ]; then
        echo "usage: getconsole consolename property"
        return 0
    fi

    if ! test -e ~/cloudpie/consoles/$1.conf; then
        return 1
    fi
    cat ~/cloudpie/consoles/${1%.*}.conf | grep "$2" | egrep -o '"[^,]*"' | egrep -o '[^"]*'
}
