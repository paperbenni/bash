#!/usr/bin/env bash
pname install/install
# install the package with the package manager $1
altinstall() {
    ALTIFS="$IFS"
    PKGMANAGER="$1"
    shift
    if echo "$@" | grep -q ':'; then
        for ARGUMENT in "$@"; do
            if echo "$ARGUMENT" | grep -q ':'; then
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
                echo "installing $ARGUMENT"
                eval "sudo $PKGMANAGER $ARGUMENT" >/dev/null
            fi
        done
    else
        echo "installing $ARGUMENT"
        eval "sudo $PKGMANAGER $ARGUMENT" >/dev/null
    fi

}

# installs programs and automatically detects the package manager
pinstall() {

    if ! command -v sudo &>/dev/null; then
        source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
        pb sudo/fakesudo.sh
    fi

    if [ -z "$1" ]; then
        echo "usage pinstall packages"
        return
    fi

    if command -v apt-get &>/dev/null; then
        echo "updating repos"
        sudo apt-get update >/dev/null
        altinstall "apt-get install -y" "$@"
    fi

    if command -v pacman &>/dev/null; then
        altinstall "pacman -S --noconfirm" "$@"
    fi

    if command -v apk &>/dev/null; then
        altinstall "apk add --update" "$@"
    fi

    if command -v yum &>/dev/null; then
        altinstall "yum install -y" "$@"
    fi

}
