#!/usr/bin/env bash

altinstall() {
    ALTIFS="$IFS"
    PKGMANAGER="$1"
    shift
    if echo "$@" | grep ':'; then
        for ARGUMENT in "$@"; do
            if echo "$ARGUMENT" | grep ':'; then
                for IPROGRAM in ${ARGUMENT//:/ }; do
                    echo "trying $IPROGRAM"
                    if eval "sudo $PKGMANAGER $IPROGRAM"; then
                        break
                    else
                        echo "pkg $IPROGRAM not found, skipping"
                    fi
                done
                IFS="$ALTIFS"
            else
                eval "sudo $PKGMANAGER $ARGUMENT"
            fi
        done
    else
        eval "sudo $PKGMANAGER $ARGUMENT"
    fi
}

pinstall() {

    if ! sudo --version &>/dev/null; then
        source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
        pb sudo/fakesudo.sh
    fi

    if [ -z "$1" ]; then
        echo "usage pinstall packages"
        return
    fi

    if apt --version &>/dev/null; then
        sudo apt update
        altinstall "apt install -y" "$@"
    fi

    if pacman --version &>/dev/null; then
        altinstall "pacman -S" "$@"
    fi

    if apk --version &>/dev/null; then
        altinstall "apk add --update" "$@"
    fi

}
