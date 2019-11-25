#!/bin/bash

pname ngrok

# installs ngrok binary into ~/ngrok/ngrok
ngrokdl() {

    pushd . &>/dev/null

    mkdir "$HOME"/ngrok &>/dev/null
    cd "$HOME"/ngrok
    echo "downloading ngrok"

    if command -v ngrok &>/dev/null || [ -e ~/ngrok/ngrok ]; then
        echo "ngrok found"
        return 0
    fi

    if grep -qi 'alpine' /etc/os-release && [ -z "$GROK64" ]; then
        echo "alpine detected, using 32bit"
        if [ -n "$1" ]; then
            curl -so ngrok.surge.sh/ngrok32 -q
            mv ngrok32 ngrok
        else
            curl -s 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip'
        fi
    else
        [ -n "$1" ] || curl -s "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip"
        [ -n "$1" ] && curl -s ngrok.surge.sh/ngrok
    fi

    if ls ./*.zip &>/dev/null; then
        unzip ./*.zip
        rm ./*.zip
    fi

    [ "$1" = "nochmod" ] || chmod +x ./ngrok
    echo "done downloading ngrok"
    popd &>/dev/null

}

#finds and executes ngrok with the specified arguments
exegrok() {
    command -v ngrok &>/dev/null && ngrok $@ && return 0
    [ -e ~/ngrok/ngrok ] || ngrokdl
    ~/ngrok/ngrok $@
}

authgrok() {
    exegrok authtoken eNwAtCA3rrWZexCnZ1zH_5CDAMiN9RiwmXpzAJk74m
    ! [ -d ~/.ngrok2 ] && mkdir ~/.ngrok2
    local GTOKEN=$(curl -s 'https://raw.githubusercontent.com/paperbenni/bash/master/ngrok/tokens.txt' | shuf -n 1)
    [ -f ~/.ngrok2/ngrok.yml ] && rm ~/.ngrok2/ngrok.yml
    curl -so ~/.ngrok2/ngrok.yml "https://raw.githubusercontent.com/paperbenni/bash/master/ngrok/ngrok.yml"
    sed -i "s~tokenhere~$GTOKEN~" ~/.ngrok2/ngrok.yml
    [ -n "$PORT" ] && echo "ngrok port $PORT"
    sed -i "s~port~${GROKWEBPORT:-8080}~" ~/.ngrok2/ngrok.yml
}

#automatically logs in and runs ngrok
rungrok() {

    ngrokdl

    while true; do
        authgrok
        sleep 5
        exegrok "$@"
        sleep 5
    done

}

#gets your ngrok adress into stdout
getgrok() {
    NGROKPORT=$(ngrokport)
    NGROKPROTOCOLL=$(curl -s localhost:$NGROKPORT/api/tunnels | sed -r 's|([a-z]{1,5})://|\1|' | head -1)

    case $NGROKPROTOCOLL in
    tcp)
        curl -s localhost:$NGROKPORT/api/tunnels | grep -Eo 'tcp\.ngrok.io:[0-9]*'
        ;;
    http|https)
        curl -s localhost:$NGROKPORT/api/tunnels | grep -Eo 'https://.{,15}\.ngrok\.io'
        ;;
    esac
}

ngrokport() {
    nc -vz localhost 4040 &>/dev/null && NGROKPORT=4040
    [ -z "$NGROKPORT" ] && nc -vz localhost 8080 &>/dev/null && NGROKPORT=8080
    [ -z "$NGROKPORT" ] && return 1
    echo "$NGROKPORT"
}

waitgrok() {
    while ! ngrokport; do
        sleep 4
    done
}
