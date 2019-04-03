#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

#usage: mineuuid {playername}
# returns the mojang uuid fromt the username
mineuuid() {

    if [[ ! $# -eq 1 ]]; then
        echo 'Error: Expected one argument: Minecraft user name.'
        return 1
    fi

    UUID_URL=https://api.mojang.com/users/profiles/minecraft/$1
    mojang_output="$(wget -qO- $UUID_URL)"
    rawUUID=${mojang_output:7:32}
    UUID=${rawUUID:0:8}-${rawUUID:8:4}-${rawUUID:12:4}-${rawUUID:16:4}-${rawUUID:20:12}
    echo $UUID
}

# ops the user $1
# execute in the spigot folder
mcop() {

    touch ops.json
    if [ -z "$1" ]; then
        echo "usage: mcop username"
        return
    fi

    if grep "$1" <ops.json; then
        echo "user $1 is already op"
        return 0
    fi

    pb replace/replace.sh
    pb bash/bash.sh
    UUID=$(mineuuid "$1")
    APPENDFILE=$(realpath ops.json)
    if grep 'uuid' <ops.json; then
        rmlast ops.json
        rmlast ops.json
        rmlast ops.json
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
