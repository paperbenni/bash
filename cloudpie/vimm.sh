#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

function vimm() {
    curl 'https://vimm.net/vault/?p=details&id='"$1" >vimm.txt
    DLID1=$(getvimm 1 "vimm.txt")
    DLID2=$(getvimm 2 "vimm.txt")
    pb proton/proton.sh
    pb wget/fakebrowser.sh
    pb unpack/unpack.sh
    proton
    sleep 1
    fakebrowser 'https://download2.vimm.net/download.php?id='"$1"'&t1='"$DLID1"'&t2='"$DLID2"
    sudo pvpn -d
    unpack $(ls -tp | grep -v /$ | head -1)
}

function getvimm() {
    if [ "$1" = "1" ]; then
        ID1=$(cat "$2" | egrep '^<tr>' | egrep -o 'name="t1" value=".*"><input')
    else
        ID1=$(cat "$2" | egrep '^<tr>' | egrep -o 'name="t2" value=".*"><table')
    fi
    ID2=${ID1%\"*}
    ID1=${ID2##*=\"}
    echo "$ID1"
}

function curlvimm() {
    rm "$1".txt "$1"id.txt "$1"name.txt

    test -e "$1" || mkdir "$1"
    for CHARACTER in {a..z}; do
        curl 'https://vimm.net/vault/?p=list&system='"$1"'&section='"$CHARACTER" >>"$1"2.txt
    done
    cat "$1"2.txt | grep "onMouseOver" >"$1".txt
    rm "$1"2.txt
    while read p; do
        TEMPID=$(echo "$p" | egrep -o 'id=[0-9]*" onMouseOver' | egrep -o '[0-9]*')
        TEMPNAME=$(echo "$p" | egrep -o ')">.*</a></td><td style')
        TEMPNAME2=${TEMPNAME#*>}
        TEMPNAME=${TEMPNAME2%%<*}

        echo "$TEMPNAME:$TEMPID" >>SNESf.txt

    done <"$1"2.txt
    cat SNESf.txt | egrep '.:' >SNES.txt
}
