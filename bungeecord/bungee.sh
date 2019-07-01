#!/usr/bin/env bash
pname bungee/bungee

bungeedl() {
    if ! java -version; then
        pb install
        pinstall openjdk-8-jre:openjdk8:jdk8-openjdk curl
    fi
    if [ -e bungeecord.jar ]; then
        echo "bungeecord already existing!"
    else
        curl -o bungeecord.jar https://papermc.io/api/v1/waterfall/1.13/273/download
    fi

    cat eula.txt || echo "eula=true" >eula.txt #accept eula
}

bungeeadd() {
    pb replace
    insertat "servers:" "removeme\n  $1:\n    motd: $2\n    adress: $3\n    restricted: false" config.yml

}
