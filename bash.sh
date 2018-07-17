#!/bin/bash

exe() {
        /lib64/ld-linux-x86-64.so.2 "$1"
}

savet() {
        echo "$1" > "$2".txt
}

gitexe() {
        curl https://raw.githubusercontent.com/paperbenni/"$1"/master/"$2".sh | bash
}

gitget() {
        curl https://raw.githubusercontent.com/paperbenni/"$1"/master/"$2".sh
}

mkcd() {
        mkdir "$1" || echo "dir already exists"
        cd "$1" || echo "problem creating the dir"
}

pjava() {
        if [ -e ./"$1" ]
        then
                java -Xmx650m -Xms650m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -jar "$1"
        else
                echo "file not existing, trying out other jar files!"
                pjava ./*.jar
        fi
}

filetype() {
        ls ./*."$1"
        if [ $1 -eq 0 ]
        then
                return 0
        else
                return 1
        fi
}

yess() {
        while :
        do
                echo "$1"
                sleep 5
        done
}

rload() {
        rclone copy dropbox:"$1" ./"$1"
}

rmlast() {
        head -n -1 "$1" > tempfoo.txt ; mv tempfoo.txt "$1"
}

rmfirst() {
        tail -n +2 "$1" > tempfirst.txt ; mv tempfirst.txt "$1"
}
