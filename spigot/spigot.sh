#!/bin/bash

pname spigot/spigot

# downloads spigot into the current foder
spigotdl() {
    if ! java -version; then
        pb install/install.sh
        pinstall openjdk-8-jre:openjdk8:jdk8-openjdk curl
    fi
    if [ -e spigot.jar ]; then
        echo "spigot already existing!"
    else
        curl -o spigot.jar spigot.surge.sh/spigot.jar

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
        cd plugins
        test -e AutoStop.jar || wget spigot.surge.sh/AutoStop.jar
        grep "$STOPSECONDS" <AutoStop/config.yml && return 0
        mkdir AutoStop
        cd AutoStop || (cd ../ && echo "spigot autostop failed" && exit 1)
        rm config.yml
        wget spigot.surge.sh/AutoStop/config.yml
        echo "stopseconds: $STOPSECONDS" >>config.yml
        cd ../..

    fi
}

# installs an AutoRestart plugin on your spigot server
spigotautorestart() {
    ls ./plugins || return 1
    pb replace/replace.sh
    STOPTIME=${1:-1.5}
    echo "using $STOPTIME s spigot autorestart time"
    cd plugins
    test -e AutoRestart.jar || wget spigot.surge.sh/AutoRestart.jar
    grep "$STOPTIME" <AutoRestart/Main.yml && return 0
    mkdir AutoRestart
    cd AutoRestart || (cd ../ && echo "spigot autorestart failed" && exit 1)
    rm Main.yml
    wget spigot.surge.sh/AutoRestart/Main.yml
    rpstring replaceme "$1" Main.yml
    cd ../..
    rpstring "\.\/start.sh" '\.\/restart.sh' spigot.yml
    echo "autorestart installed"
    if [ -e ~/restart.sh ]; then
        echo "HOME restart.sh found"
        cp ~/restart.sh ./
    fi
}

spigotversion() {
    if ! [ -e "version_history.json" ]; then
        echo "version_history.json not found"
        return 1
    fi
    #example content: {"currentVersion":"git-Paper-610 (MC: 1.13.2)"}
    cat version_history.json | grep 'currentVersion' |
        egrep -o '[0-9].[0-9]{2}.[0-9]' |
        egrep -m 1 -o '[0-9].[0-9]{2}'
}

spigotserveo() {
    nohup autossh -M 0 -R "$1":localhost:25565 serveo.net
}
