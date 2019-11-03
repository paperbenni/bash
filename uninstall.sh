#!/bin/bash

################################################
## remove paperbash and all of its components ##
################################################

echo "completely uninstalling pb"

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb grep/sed

echo "removing papertest"
removebetween ~/.bashrc

if grep 'papertest' </etc/profile; then
    sudo removebetween /etc/profile
fi

cd

if ! [ -e workspace/bash/.git ]; then
    rm -rf workspace/bash
fi

rm .paperoff
rm .paperdebug
