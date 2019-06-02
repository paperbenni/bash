#!/usr/bin/env bash
pname cloudpie/vimm

function vimm() {
    curl 'https://vimm.net/vault/?p=details&id='"$1" >vimm.txt
    DLID1=$(getvimm "vimm.txt" 1)
    DLID2=$(getvimm "vimm.txt" 2)
    DLLINK='https://download2.vimm.net/download.php?id='"$1"'&t1='"$DLID1"'&t2='"$DLID2"

    pb wget/fakebrowser.sh
    pb unpack/unpack.sh
    sleep 1
    fakebrowser "$DLLINK"
    unpackdir
}

function getvimm() {
    cat "$1" | egrep -o "=\"t$2\""' value="[0-9a-z]*"' | sort -u | egrep -o '[a-z0-9]{6,}'
}

#https://download1.vimm.net/download.php?id=7606&t1=4d190be365b3660a305c91802f9726ce&t2=01d459a08461d23ff323621e0db2094f&download=Download
function curlvimm() {
    rm "$1".txt "$1"id.txt "$1"name.txt

    test -e "$1" || mkdir "$1"
    for CHARACTER in {a..z}; do
        curl 'https://vimm.net/vault/?p=list&system='"$1"'&section='"$CHARACTER" >>"$1"2.txt
    done

    cat "$1"2.txt | egrep -i 'mouse' | egrep -o '>[^<>/]{6,}</a' | egrep -o '[^>].*' | egrep -o '.*[^</a]' >"$1.txt"
}
