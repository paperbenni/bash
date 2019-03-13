#!/usr/bin/env bash

rmlast() {
    head -n -1 "$1" >tempfoo.txt
    mv tempfoo.txt "$1"
}

rmfirst() {
    tail -n +2 "$1" >tempfirst.txt
    mv tempfirst.txt "$1"
}

preappend() {
    echo -e "$1\n$(cat $2)" >$2
}

rpstring() {
    sed -i -e "s/$1/$2/g" $3
}
