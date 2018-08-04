#!/bin/bash

if [ -e spigot.jar ]
then
  echo "spigot already existing!"
else
  curl -o spigot.jar https://destroystokyo.com/ci/job/Paper/lastSuccessfulBuild/artifact/paperclip.jar
fi

if [ -e cache ]; then
   echo "cache exists."
else
    mkdir cache
    cd cache || echo "no cache" || echo "no cache"
    echo "downloading minecraft 1.12"
    curl -o mojang_1.12.2.jar https://spigot.surge.sh/cache/mojang_1.12.2.jar
    echo "downloading patched 1.12"
    curl -o patched_1.12.2.jar https://spigot.surge.sh/cache/patched_1.12.2.jar
    cd ..
fi 

echo "eula=true" > eula.txt #accept eula

java -Xmx650m -Xms650m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -jar spigot.jar
