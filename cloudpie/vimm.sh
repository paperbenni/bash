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
    egrep -o 'name="t2" value=".{,33}"><input' |
        head -1 |
        egrep -o 'value=.*' |
        egrep -o '".*"' |
        egrep -o '[^"]*'
}

getvimm1() {
    egrep -o 'name="t1" value=".{,33}"><input' |
        head -1 |
        egrep -o 'value=.*' |
        egrep -o '".*"' |
        egrep -o '[^"]*'
}

vimmmedia() {
    egrep -o 'name="mediaId" value="[0-9]{4,}"' | egrep -o '[0-9]*' | head -1
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

    egrep -i 'mouse' <"$1"2.txt | egrep -o '>[^<>/]{6,}</a' | egrep -o '[^>].*' | egrep -o '.*[^</a]' >"$1.txt"
}
