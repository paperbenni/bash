#!/bin/bash
pname python

# install python package from git repo
installpip() {
    zerocheck "$1"

    gitclone "$1"
    cd "${1#*/}" || return 1
    [ -e setup.py ] || return 1
    [ -e dist ] && rm -rf dist/*

    python3 setup.py sdist bdist_wheel

    cd dist
    pip3 install --user ./*.whl

}

# virtualenv wrapper that downloads, compiles and installs a python version before using it
pyenv() {

    if ! command -v virtualenv &>/dev/null; then
        echo "please install virtualenv"
        echo "sudo pip3 install virtualenv"
        return
    fi

    # scrape version numbers from website
    if [ -z "$@" ]; then
        echo "list of python versions"
        curl -s https://www.python.org/downloads/ | grep -o 'Python [0-9]\.[0-9]\.[0-9]' | sort -u | tac
        return
    fi

    if ! grep -Eiq '(3|2|2)\.[0-9]\.[0-9]' <<<"$1"; then
        echo "please specify a python version number"
        return 1
    fi

    # download and compile if the python version is not installed
    if ! [ -e ~/.cache/pyenv/$1/mybuild ]; then
        pushd .
        cd
        mkdir -p .cache/pyenv
        cd .cache/pyenv
        mkdir "$1"
        cd "$1"
        wget -O python.tar.xz https://www.python.org/ftp/python/$1/Python-$1.tar.xz

        if ! unxz python.tar.xz; then
            cd ..
            rm -rf "$1"
            popd
            echo "error: python version not existing"
            return 1
        fi

        tar xvf python.tar
        PYPATH="$(pwd)"
        cd Python-*
        ./configure --prefix="$PYPATH"/mybuild
        make
        make install
        popd
    fi

    # create virtualenv and source activation script
    if ! [ -e ./bin/activate ]; then
        if [ -e "$HOME"/.cache/pyenv/$1/mybuild/bin/python3 ]; then
            virtualenv --python "$HOME"/.cache/pyenv/$1/mybuild/bin/python3 .
        elif [ -e "$HOME"/.cache/pyenv/$1/mybuild/bin/python2 ]; then
            virtualenv --python "$HOME"/.cache/pyenv/$1/mybuild/bin/python3 .
        else
            echo "error: no python binary in $HOME/.cache/pyenv/$1/mybuild/bin/"
            return
        fi
    fi
    source ./bin/activate

}
