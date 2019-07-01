#!/usr/bin/env bash
pname titlesite/titlesite

#generates a simple website with two titles
# usage: titlesite template foldername title subtitle
titlesite() {
    pb git
    pb replace
    TITLETEMPLATE=${1:-glitch}
    TITLEDEST=${2:quark}
    gitfolder paperbenni/titlesites "$TITLETEMPLATE"
    mv "$TITLETEMPLATE" "$TITLEDEST"
    cd "$TITLEDEST"
    rpstring "titleplace" "${3:-titletemplate}" index.html
    rpstring "subplace" "${4:-titlesubtitle}" index.html
    cd ..
}
