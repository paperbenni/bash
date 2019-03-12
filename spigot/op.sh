#!/bin/bash

#usage: mineuuid {playername}
mineuuid() {
    if [ -n $1 ]; then
        curl https://api.mojang.com/users/profiles/minecraft/$PLAYERNAME | jq -r '.id'
    else
        echo "usage: muneuuid [playername]"
    fi
}

mcop() {
    if [ -z "$1" ]; then
        echo "usage:
    mcop username"
        return
    fi
    UUID=$(mineuuid "$1")
}
