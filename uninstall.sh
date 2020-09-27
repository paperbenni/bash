#!/bin/bash

################################################
## remove paperbash and all of its components ##
################################################

echo "completely uninstalling paperbash"
cd || exit 1

if ! [ -e workspace/bash/import.sh ]; then
    rm -rf workspace/bash
fi

sed -i '/source.*paperbashsource/d' ~/.bashrc

rm .paperoff
rm .paperdebug
