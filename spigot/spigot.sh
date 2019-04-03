#!/bin/bash

# downloads spigot into the current foder
spigotdl() {
    if ! java -version; then
        pb install/install.sh
        pinstall openjdk-8-jre:openjdk8:jdk8-openjdk curl
    fi
    if [ -e spigot.jar ]; then
        echo "spigot already existing!"
    else
        curl -o spigot.jar https://papermc.io/api/v1/paper/1.13.2/597/download

    fi

    cat eula.txt || echo "eula=true" >eula.txt #accept eula
}

# usage: spigexe {ammount of memory}
spigexe() {
    spigotdl
    if [ -z $1 ]; then
        java -Xmx650m -Xms650m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -jar spigot.jar
    else
        java -Xmx$1m -Xms$1m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -jar spigot.jar
    fi
}

# adds an AutoStop plugin to spigot that automatically stops the server after $1 seconds
spigoautostop() {
    if [ -e plugins ]; then
        STOPSECONDS=${1:-7200}
        echo "using $STOPSECONDS s spigot autostop time"
        pushd plugins
        test -e AutoStop.jar || wget spigot.surge.sh/AutoStop.jar
        grep "$STOPSECONDS" <AutoStop/config.yml && return 0
        mkdir AutoStop
        cd AutoStop
        rm config.yml
        wget spigot.surge.sh/AutoStop/config.yml
        echo "stopseconds: $STOPSECONDS" >>config.yml

        popd

    fi
}
