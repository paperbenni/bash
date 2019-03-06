#!/bin/bash

#usage: mineuuid {playername}
mineuuid() {
    if [ -n $1 ]; then
        echo "getting uuid for $1"
        curl https://api.mojang.com/users/profiles/minecraft/$PLAYERNAME | jq -r '.id'
    else
        echo "usage: muneuuid [playername]"
    fi
}
