#!/bin/bash

# install paperbash locally

cd || exit 1
mkdir -p workspace
cd workspace || exit 1
git clone --depth=1 https://github.com/paperbenni/bash.git
source ./bash/import.sh || exit 1
cd || exit 1

if grep -q 'paperbashsource' ~/.bashrc
then
    echo "already installed"
    exit 
fi

echo 'source ~/workspace/bash/import.sh # paperbashsource do not change this comment'>> .bashrc

echo 'offline' >~/.paperoff
