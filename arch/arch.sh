#!/bin/bash
pname arch/arch

aurinstall() {
    if ! command -v "makepkg" &>/dev/null && grep -qiE '(arch|manjaro)' </etc/os-release; then
        echo "your os doesn't support the AUR" >&2
        return 1
    fi
    #pushd . &>/dev/null
    (
        cd
        mkdir -p .cache/aur
        cd .cache/aur
        if ! [ -e "$1" ]; then
            git clone "https://aur.archlinux.org/$1.git"
            cd "$1"
        else
            cd "$1"
            git reset --hard
            git pull
        fi

        if pacman -Qi "$1" &>/dev/null; then
            echo "already installed"
            return 0
        fi

        makepkg .
        sudo pacman -U --noconfirm ./*.pkg.tar.xz
    )
    rm -rf "$1"

    #popd &>/dev/null
}
