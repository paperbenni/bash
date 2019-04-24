#!/usr/bin/env bash
mpm() {

    pb spigot

    MPMLINK="https://github.com/paperbenni/mpm/raw/master"
    if [ -n "$2" ]; then
        MCVERSION="$(curl MPMLINK/latest)"
    else
        MCVERSION="$2"
    fi

    echo "starting mpm"
    if [ -e plugins ] && [ -e spigot.jar ]; then
        echo "minecraft server found"
    else
        echo "minecraft server not found"
        return 0
    fi

    SPIGOTVERSION="$(spigotversion)"

    cd plugins

    #check for new version if the plugin is installed
    if [ -e "$1.mpm"]; then
        OLDVERSION="$(grep version <"$1.mpm" | egrep -o '[0-9]*')"
        NEWVERSION="$(curl "$MPMLINK/plugins/$1.mpm" | grep 'version' | egrep -o '[0-9*]')"
        if [ "$OLDVERSION" = "$NEWVERSION" ]; then
            echo "newest version of $1 already installed"
            return 0
        else
            echo "$1 outdated, updating..."
            rm "$1."*
        fi

    fi

    #download metadata
    curl "$MPMLINK/plugins/$1.mpm" >"$1.mpm"

    #check if the plugin exists
    if ! grep 'describe' <"$1.mpm"; then
        echo "plugin $1 not existing on remote"
        rm $1.mpm
        return 1
    fi

    if grep "$SPIGOTVERSION" <"$1.mpm"; then
        echo "version check sucessful"
    fi

}
