#!/bin/bash

# appends to previously set APPENDFILE
app() {
    if [ -z "$APPENDFILE" ]; then
        echo "append to a \$APPENDFILE"
        echo "usage: app string"
        return 1
    fi
    if [ -e "$APPENDFILE" ]; then
        echo "$1" >>"$APPENDFILE"
    fi
}

#get last exit status
gexit() {
    echo "$?"
}

#alternative binary execution
exe() {
    /lib64/ld-linux-x86-64.so.2 "$1"
}

#download file from paperbenni's github
gitget() {
    curl https://raw.githubusercontent.com/paperbenni/"$1"/master/"$2"
}

# create and cd into dir
mkcd() {
    mkdir "$1" || echo "dir already exists"
    cd "$1" || echo "problem creating the dir"
}

#jar opener with settings
pjava() {
    if [ -e ./"$1" ]; then
        java -Xmx650m -Xms650m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -jar "$1"
    else
        echo "file not existing, trying out other jar files!"
        pjava ./*.jar
    fi
}

#returns the file extension of $1
filetype() {
    ls ./*."$1"
    if [ $1 -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

#slower version of yes
yess() {
    while :; do
        echo "$1"
        sleep 5
    done
}

#dialog confirm promt that returns exit status
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
    [yY][eE][sS] | [yY])
        true
        ;;
    *)
        false
        ;;
    esac
}

loop() {
    if [ "$1" -eq "$1" ]; then
        LOOPI="$1"
        shift 1
        for i in $(seq "$LOOPI"); do
            eval "$@"
        done
    else
        while :; do
            eval "$@"
            sleep 1
        done
    fi
}

random() {
    MAX=$(echo $(($2 - $1)))
    echo $((($RANDOM % $MAX) + $1))
}
