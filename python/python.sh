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

# download and compile a python version to use in a virtualenv
pyenv() {
    if [ -n "$@" ]; then
        echo "list of python versions"
        curl -s https://www.python.org/downloads | grep -o 'Python [0-9]\.[0-9]\.[0-9]' | sort -u | tac
        return
    fi

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
    cd Python-*
    ./configure --prefix="$(pwd)"/mybuild
    make
    make install

    popd
}
