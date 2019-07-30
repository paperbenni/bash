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
    wget "$2"
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
    if ! [ -e "$1" ]; then
        echo "$1 not found"
        exit 0
    fi
    case "$2" in
    n64)
        retro "mupen64plus_libretro" "$1"
        ;;
    ds)
        retro "desmume2015_libretro" "$1"
        ;;
    snes)
        retro "snes9x_libretro" "$1"
        ;;
    psx)
        retro "pcsx_rearmed_libretro" "$1"
        ;;
    gba)
        retro "vbam_libretro" "$1"
        ;;
    nes)
        retro "nestopia_libretro" "$1"
        ;;
    gbc)
        retro "gambatte_libretro" "$1"
        ;;

    *)
        echo "no core found for $2"
        ;;
    esac

}

function repoload() {
    # $1 is the link
    # $2 is the repo file name
    # $3 is the system name
    # $4 is the file extension
    pb wget/curl
    echo "updating $(echo $1 | urldecode) repos"
    sleep 1
    getlinks "https://the-eye.eu/public/rom/$1/" >"$2.txt"
    debug "https://the-eye.eu/public/rom/$1/"
    # add the link prefix as the last line
    echo "https://the-eye.eu/public/rom/$1/" >>"$2".txt
}

function romupdate() {

    pushd ~/
    cd cloudpie/consoles || return 1
    for i in ./*; do
        echo "repos for $i"
        REPOLINK=$(cat "$i" | grep 'link' | betweenquotes)
        if ! echo "$REPOLINK" | grep 'http'; then
            LINK="https://the-eye.eu/public/rom/$REPOLINK/"
        else
            LINK="$REPOLINK"
        fi
        repoload "$LINK" "${i%.*}"
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

        while ! test -e ~/cloudpie/saves/cloud.txt; do
            if ! pgrep dmenu; then
                echo "waiting for cloud saves"
            fi
            sleep 5
        done

    fi
}
