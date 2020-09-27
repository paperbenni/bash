#!/bin/bash

# install paperbash locally

cd || exit 1
mkdir -p workspace
cd workspace || exit 1
git clone --depth=1 https://github.com/paperbenni/bash.git
rm -rf bash/.git

cd || exit 1

if grep -q 'workspace/bash/import.sh' ~/.bashrc
then
    echo "already installed"
    exit 
fi
appendmarkers 'source ~/workspace/bash/import.sh' .bashrc
sudo appendmarkers 'source ~/workspace/bash/import.sh' /etc/profile

echo 'offline' >~/.paperoff
