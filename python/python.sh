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
