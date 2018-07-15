#!/bin/bash

exe() {
        /lib64/ld-linux-x86-64.so.2 "$1"
}

savet() {
        echo "$1" > "$2".txt
}

gitexe() {
        curl https://raw.githubusercontent.com/paperbenni/"$1"/master/"$2".sh | bash
}

gitget() {
        curl https://raw.githubusercontent.com/paperbenni/"$1"/master/"$2".sh
}

mkcd() {
        mkdir "$1" || echo "dir already exists"
        cd "$1" || echo "problem creating the dir"
}
