#!/usr/bin/env bash

pname spigot/mpm

mpm() {

    if [ "$1" = "-f" ]; then
        if [ -e "mpmfile" ]; then
            while read p; do
                mpm "$p"
                echo "$p"
            done <mpmfile
        else
            echo "put your plugin names in mpmfile"
        fi
        return 0
    fi

    pb spigot

    MPMLINK="https://raw.githubusercontent.com/paperbenni/mpm/master"

    echo "starting mpm"
    if [ -e plugins ] && [ -e spigot.jar ]; then
        echo "minecraft server found"
    else
        echo "minecraft server not found"
        return 0
    fi

    if [ -z "$2" ]; then
        MCVERSION="$(spigotversion)"
    else
        MCVERSION="$2"
    fi

    echo "minecaft version $MCVERSION"
    SPIGOTVERSION="$(spigotversion)"

    cd plugins

    #check for new version if the plugin is installed
    if [ -e "$1.mpm" ]; then
        OLDVERSION="$(grep version <"$1.mpm" | egrep -o '[0-9]*')"
        NEWVERSION="$(curl "$MPMLINK/plugins/$1/$MCVERSION/$1.mpm" | grep 'version' | egrep -o '[0-9]*')"
        if [ "$OLDVERSION" = "$NEWVERSION" ]; then
            echo "newest version of $1 already installed"
            cd ..
            return 0
        else
            echo "$1 outdated, updating..."
            rm "$1."*
        fi

    fi

    #download metadata
    echo "$MPMLINK/plugins/$1/$MCVERSION/$1.mpm"
    curl "$MPMLINK/plugins/$1/$MCVERSION/$1.mpm" >"$1.mpm"
    #cat "$1.mpm"
    #check if the plugin exists
    if ! grep 'describe' <"$1.mpm"; then
        echo "plugin $1 not existing on remote"
        #rm $1.mpm
        return 1
    fi

    if grep "$SPIGOTVERSION" <"$1.mpm"; then
        echo "version check sucessful"
    fi
    wget "$MPMLINK/plugins/$1/$MCVERSION/$1.jar"
    echo "installed $1.jar"

    if grep 'depend' <"$1.mpm"; then
        echo "plugin needs dependencies"
        DPENDENCIES="$(grep 'depend' <$1.mpm)"
        cd ../
        for i in "$DPENDENCIES"; do
            echo "installing dependency $i"
            pwd
            mpm "${i#**:}"
        done
        cd plugins
    fi

    cd ..

}
