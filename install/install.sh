#!/usr/bin/env bash
pname install/install

# install the package with the package manager $1
altinstall() {
    ALTIFS="$IFS"
    PKGMANAGER="$1"
    shift
    if [[ "$*" == *:* ]]; then
        for ARGUMENT in "$@"; do
            if [[ "$ARGUMENT" == *:* ]]; then
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
                command -v "$ARGUMENT" && return
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
        pb sudo/fakesudo
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

# sets up an executable like a global program
usrbin() {

    case "$1" in
    -f)
        FORCEBIN="True"
        shift
        ;;
    -c)
        COPYFILE=True
        shift
        ;;
    esac

    if ! [ -e "$1" ]; then
        echo "target not existing"
        return 1
    fi

    if ! [ -n "$FORCEBIN" ]; then
        if command -v "${1##*/}" &>/dev/null; then
            echo "conflicting command name"
            return 1
        fi
    else
        unset FORCEBIN
    fi

    if [ -n "$COPYFILE" ] || [ "$2" = "-c" ]; then
        sudo cp "$1" /usr/local/bin/"${1##*/}"
    else
        sudo mv "$1" /usr/local/bin/"${1##*/}"
    fi

    sudo chmod 755 /usr/local/bin/"${1##*/}"
    sudo chown 0:0 /usr/local/bin/"${1##*/}"

}
