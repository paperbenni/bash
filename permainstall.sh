#!/bin/bash
cd
mkdir -p workspace
cd workspace
git clone --depth=1 https://github.com/paperbenni/bash.git
echo 'source ~/workspace/bash/import.sh' >>~/.bashrc
echo 'source ~/workspace/bash/import.sh' | sudo tee -a /etc/profile
echo 'offline' >~/.paperoff
