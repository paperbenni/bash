#!/bin/bash

# install paperbash locally

cd || exit 1
mkdir -p workspace
cd workspace || exit 1
git clone --depth=1 https://github.com/paperbenni/bash.git
source ./bash/import.sh || exit 1
cd || exit 1

if grep -q 'workspace/bash/import.sh' ~/.bashrc
then
    echo "already installed"
    exit 
fi

appendmarkers 'source ~/workspace/bash/import.sh' .bashrc

echo 'offline' >~/.paperoff
