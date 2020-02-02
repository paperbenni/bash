#!/usr/bin/env bash
# currently does not work

pname cloudpie/vimm
pb wget/fakebrowser
pb unpack

function vimm() {
    curl "https://vimm.net/vault/$1" >vimm.txt
    DLID1=$(getvimm1 <vimm.txt)
    DLID2=$(getvimm2 <vimm.txt)
    MEDIA=$(vimmmedia <vimm.txt)
    sleep 1
    URL="$(vimmlink $MEDIA $DLID1 $DLID2)"
    fakebrowser "$URL"
    unpackdir
}

getvimm2() {
    grep -Eo 'name="t2" value=".{,33}"><input' |
        head -1 |
        grep -o 'value=.*' |
        grep -o '".*"' |
        grep -o '[^"]*'
}

getvimm1() {
    grep -Eo 'name="t1" value=".{,33}"><input' |
        head -1 |
        grep -o 'value=.*' |
        grep -o '".*"' |
        grep -o '[^"]*'
}

vimmmedia() {
    grep -Eo 'name="mediaId" value="[0-9]{4,}"' | grep -o '[0-9]*' | head -1
}

vimmlink() {
    echo "https://download.vimm.net/download.php?mediaId=$1&t1=$2&t2=$3&download=Download"
}

function curlvimm() {
    rm "$1".txt "$1"id.txt "$1"name.txt

    test -e "$1" || mkdir "$1"
    for CHARACTER in {a..z}; do
        curl 'https://vimm.net/vault/?p=list&system='"$1"'&section='"$CHARACTER" >>"$1"2.txt
    done

    grep -i 'mouse' <"$1"2.txt | grep -Eo '>[^<>/]{6,}</a' | grep -o '[^>].*' | grep -o '.*[^</a]' >"$1.txt"
}
