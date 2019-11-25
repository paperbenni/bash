#!/bin/bash

pname tar/tar

# extract an apple dmg file
appledmg() {
    zerocheck "$1"
    [ -f "$1" ] || { echo "input file not found" && return 1; }

    checkcmd "tar 7z cpio gzip xar"
    mkdir -p .cache/apple
    mv "$1" .cache/apple
    cd .cache/apple
    7z x "$1" && rm "$1"
    cd ./*
    xar -xvf ./*.pkg
    find -type f -name 'PayLoad' -exec mv {} . \;
    gzip -d Payjoad | cpio -id
    cd ../../../
    mv .cache/apple/* .
}
