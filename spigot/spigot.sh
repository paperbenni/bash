#!/bin/bash

pname spigot/spigot

# downloads spigot into the current foder
spigotdl() {

    if echo "$1" | grep '1.'; then
        MC="$1"
    else
        MC="$(curl -s https://raw.githubusercontent.com/paperbenni/mpm/master/latest)"
    fi
    echo "downloading minecraft version $MC"
    if ! java -version; then
        pb install
        pinstall openjdk-8-jre:openjdk8:jdk8-openjdk curl
    fi
    echo "downloading https://raw.githubusercontent.com/paperbenni/mpm/master/spigot/$MC/spigot.jar"
    if [ -e spigot.jar ]; then
        echo "spigot already existing!"
    else
        wget -q "https://raw.githubusercontent.com/paperbenni/mpm/master/spigot/$MC/spigot.jar"
    fi

    test -e server-icon.png ||
        wget -q "https://raw.githubusercontent.com/paperbenni/paperbenni.github.io/master/paperbenni64.png"
    mv paperbenni64.png server-icon.png
    cat eula.txt || echo "eula=true" >eula.txt #accept eula

    test -e bukkit.yml || wget -q raw.githubusercontent.com/paperbenni/mpm/master/spigot/$MC/bukkit.yml
    test -e paper.yml || wget -q raw.githubusercontent.com/paperbenni/mpm/master/spigot/$MC/paper.yml
    test -e spigot.yml || wget -q raw.githubusercontent.com/paperbenni/mpm/master/spigot/$MC/spigot.yml
    test -e server.properties || wget -q raw.githubusercontent.com/paperbenni/mpm/master/spigot/$MC/server.properties
    ls *.html &>/dev/null && rm *.html

}

# usage: spigexe MCVERSION {ammount of memory}
spigexe() {
    if [ "$1" = "-f" ]; then
        java -jar spigot.jar
        return 0
    fi
    spigotdl "$1"

    if [ -z $2 ]; then
        java -Xmx500m -Xms500m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -jar spigot.jar
    else
        java -Xmx${2}m -Xms${2}m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -jar spigot.jar
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

    pb replace
    pb spigot/mpm
    mpm autorestart

    cd plugins

    echo "using $STOPTIME s spigot autorestart time"
    STOPTIME=${1:-1.5}
    grep "$STOPTIME" <AutoRestart/Main.yml && return 0

    mkdir AutoRestart
    cd AutoRestart || (cd ../ && echo "spigot autorestart failed" && exit 1)
    #set timer
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

    if [ -n "$MINECRAFTVERSION" ]; then
        echo "$MINECRAFTVERSION"
        return 0
    fi

    if [ -n "$HSPIGOT" ]; then
        echo "$HSPIGOT"
        return 0
    fi

    if ! [ -e "version_history.json" ]; then
        echo "version_history.json not found"
        return 1
    fi

    #example content: {"currentVersion":"git-Paper-610 (MC: 1.xx.x)"}

    cat version_history.json |
        egrep -o 'currentVersion.*' |
        egrep -o 'MC: 1\.[0-9]{1,}' |
        egrep -o '1\.[0-9]{1,}'
}

spigotserveo() {
    nohup autossh -M 0 -R "$1":localhost:25565 serveo.net
}

checkspigot() {
    if [ -e plugins ] && [ -e spigot.jar ]; then
        echo "minecraft server found"
        return 0
    else
        echo "minecraft server not found"
        return 1
    fi
}
