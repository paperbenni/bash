#!/usr/bin/env bash
pname unpack/unpack

#automatically determines filetype and extracts the archive
unpack() {
    if [ -z "$1" ]; then
        echo "usage: unpack file
      automatically detects the archive type and extracts it"
        return
    fi

    (
        command -v tar
        command -v unzip
        command -v unrar
        command -v 7z
    ) &>/dev/null

    CHECKSTAT="$?"
    if ! [ "$CHECKSTAT" = 0 ]; then
        pb install
        pinstall tar unzip unrar
    fi

    if ls "$1"; then
        case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.tar.xz) tar xvf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar e "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *)
            echo "$1 is not an archive"
            return 0
            ;;
        esac
    else
        echo "$1 is not a valid file"
        return 1
    fi

    if [ "$2" = "rm" ]; then
        rm "$1"
    fi
}

unpackdir() {
    pushd "$1"
    for i in ./*; do
        case "$i" in
        *.tar.bz2) tar xjf "$i" ;;
        *.tar.gz) tar xzf "$i" ;;
        *.tar.xz) tar xvf "$i" ;;
        *.bz2) bunzip2 "$i" ;;
        *.rar) unrar e "$i" ;;
        *.gz) gunzip "$i" ;;
        *.tar) tar xf "$i" ;;
        *.tbz2) tar xjf "$i" ;;
        *.tgz) tar xzf "$i" ;;
        *.zip) unzip "$i" ;;
        *.Z) uncompress "$i" ;;
        *.7z) 7z x "$i" ;;
        *)
            echo "$i is not an archive"
            continue
            ;;
        esac
        rm "$i"
    done
    popd
}

# extract an apple dmg file
appledmg() {
    zerocheck "$1"
    [ -e "$1" ] || { echo "input file not found" && return 1; }
    checkcmd "7z cpio"

    mkdir -p .cache/apple
    mv "$1" .cache/apple
    cd .cache/apple

    7z x "$1"
    rm "$1"

    cd *
    mv * ../
    cd ..

    mv *.pkg file.xar
    7z x file.xar

    mv *Payload Payload
    cpio -i -F Payload

    mv ./* ../../
    cd ../../
}
