#!/bin/bash
echo "running surge.sh"
if [ -f surge.txt ]
then
        SURGEADRESS=$(cat ./surge.txt)
        surge . "$SURGEADRESS".surge.sh || \
                (sudo npm install -g surge && surge . "$SURGEADRESS".surge.sh) || \
                (sudo apt update && sudo apt upgrade -y && sudo apt install nodejs && sudo npm install -g surge && surge . "$SURGEADRESS".surge.sh)
else
        echo "surge.txt missing!"
fi
