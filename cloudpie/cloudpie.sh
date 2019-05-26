#!/usr/bin/env bash
pname cloudpie/cloudpie

#exits if arg is null
function zerocheck() {
    if [ -z "$1" ]; then
        exit
    fi
}

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
    pb replace
    rm "$2".txt
    echo "updating $(echo $1 | urldecode) repos"

    curl https://the-eye.eu/public/rom/$1/ >"$2".2.tmp
    if ! grep "z64" <"$2.2.tmp"; then
        curl http://the-eye.eu/public/rom/$1/ >"$2".2.tmp
    fi

    #decodes spaces and other characters from html links
    sed -n 's/.*href="\([^"]*\).*/\1/p' "$2".2.tmp >"$2.tmp"
    rm "$2.2.tmp"
    cat "$2".tmp | urldecode >"$2".txt
    rm "$2".tmp

    rmstring 'https' "$2.txt"
    rmstring '\.\.\/' "$2.txt"

    # add the link prefix as the last line
    echo "https://the-eye.eu/public/rom/$1/" >>"$2".txt
    sleep 1

}

function romupdate() {

    mkdir -p ~/cloudpie/repos
    pushd ~/cloudpie/repos

    repoload 'Nintendo%2064/Roms' n64
    repoload 'SNES' snes
    repoload 'Playstation/Games/NTSC' psx
    repoload 'Nintendo%20Gameboy%20Advance' gba
    repoload 'Nintendo%20DS' ds
    repoload 'NES' nes
    repoload 'Nintendo%20Gameboy%20Color' gbc

    popd
}
