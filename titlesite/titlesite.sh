#!/usr/bin/env bash
pname titlesite/titlesite

#generates a simple website with two titles
# usage: titlesite template foldername title subtitle
titlesite() {
    pb git
    pb replace
    gitfolder paperbenni/titlesites "$1"
    mv "$1" "$2"
    cd "$2"
    rpstring "titleplace" "$3" index.html
    rpstring "subplace" "$4" index.html
    cd ..
}
