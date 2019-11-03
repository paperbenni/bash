#!/usr/bin/env bash

####################################################
## set up a development environment for paperbash ##
####################################################

cd

if grep -i 'papertest' <.bashrc; then
    echo "papertest already installed"
    exit
fi

touch .paperdebug

echo "setting up pb development environment"
curl https://raw.githubusercontent.com/paperbenni/bash/master/debugger.sh >>.bashrc
