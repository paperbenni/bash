#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

#usage: mineuuid {playername}
mineuuid() {
    if [ -n $1 ]; then
        curl https://api.mojang.com/users/profiles/minecraft/$PLAYERNAME | jq -r '.id'
    else
        echo "usage: muneuuid [playername]"
    fi
}

mcop() {
    if ! [ -e ops.json ]; then
        echo "ops.json not found"
        return
    fi

    if [ -z "$1" ]; then
        echo "usage: mcop username"
        return
    fi

    pb replace/replace.sh
    pb bash/bash.sh
    UUID=$(mineuuid "$1")
    rmlast ops.json
    rmlast ops.json
    APPENDFILE=$(realpath ops.json)
    app "}, \r{"
    app "\"uuid\": \"$UUID\", "
    app "\"name\": \"$1\", "
    app "\"level\": 4, "
    app "\"bypassesPlayerLimit\": false"
    app "}\r]"
}
