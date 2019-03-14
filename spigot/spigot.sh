#!/bin/bash

spigotdl() {
    if ! java -version; then
        pb install/install.sh
        pinstall openjdk-8-jre:openjdk8:jdk8-openjdk
    fi
    if [ -e spigot.jar ]; then
        echo "spigot already existing!"
    else
        curl -o spigot.jar https://papermc.io/api/v1/paper/1.13.2/565/download
    fi

    echo "eula=true" >eula.txt #accept eula
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
