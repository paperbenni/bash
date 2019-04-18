#!/usr/bin/env bash

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
        pb install/install.sh
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
            echo "'$1' cannot be extracted via extract()"
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
