#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

#usage: mineuuid {playername}
# returns the mojang uuid fromt the username
mineuuid() {

    if [ -z "$1" ]; then
        echo 'Error: usage: mineuuid name [offline]'
        return 1
    fi
    if [ -z "$2" ]; then
        UUID_URL=https://api.mojang.com/users/profiles/minecraft/$1
        mojang_output="$(wget -qO- $UUID_URL)"
        rawUUID=${mojang_output:7:32}
        UUID=${rawUUID:0:8}-${rawUUID:8:4}-${rawUUID:12:4}-${rawUUID:16:4}-${rawUUID:20:12}
        echo $UUID
    else
        rawUUID=$(curl -s http://tools.glowingmines.eu/convertor/nick/"$1")
        rawUUID2=${rawUUID#*teduuid\":\"}
        UUID=${rawUUID2%\"*}
        echo "$UUID"
    fi
}

# ops the user $1
# execute in the spigot folder
mcop() {

    touch ops.json
    if [ -z "$1" ]; then
        echo "usage: mcop username"
        return
    fi

    pb replace/replace.sh
    pb bash/bash.sh

    if [ -z "$2" ]; then
        UUID=$(mineuuid "$1")
    else
        UUID=$(mineuuid "$1" offline)
    fi

    if grep "$UUID" <ops.json; then
        echo "already op"
        return 0
    fi

    APPENDFILE=$(realpath ops.json)
    if grep 'uuid' <ops.json; then
        rmlast ops.json 3
        app "  },"
    else
        rm ops.json
        touch ops.json
        app "["
    fi

    app "  {"
    app "    \"uuid\": \"$UUID\", "
    app "    \"name\": \"$1\", "
    app "    \"level\": 4, "
    app "    \"bypassesPlayerLimit\": false"
    app "  }"
    app "]"
    app ""
}
