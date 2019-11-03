#!/bin/bash
cd
mkdir -p workspace
cd workspace
git clone --depth=1 https://github.com/paperbenni/bash.git
rm -rf bash/.git

cd
appendmarkers 'source ~/workspace/bash/import.sh' .bashrc
sudo appendmarkers 'source ~/workspace/bash/import.sh' /etc/profile

echo 'offline' >~/.paperoff
