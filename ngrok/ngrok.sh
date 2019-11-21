#!/bin/bash

pname ngrok

# installs ngrok binary into ~/ngrok/ngrok
ngrokdl() {
    mkdir "$HOME"/ngrok &>/dev/null
    cd "$HOME"/ngrok
    echo "downloading ngrok"

    if command -v ngrok &>/dev/null || [ -e ~/ngrok/ngrok ]; then
        echo "ngrok found"
        return 0
    fi

    if grep -qi 'Alpine' </etc/os-release && [ -z "$GROK64" ]; then
        echo "alpine detected, using 32bit"
        wget ngrok.surge.sh/ngrok32 -q
        mv ngrok32 ngrok
    else
        wget ngrok.surge.sh/ngrok -q
    fi

    if [ "$1" = "nochmod" ]; then
        echo "skipping chmod"
    else
        chmod +x "$HOME"/ngrok/ngrok
        if ! "$HOME"/ngrok/ngrok --version; then
            echo "failed"
        fi
        return 1
    fi

}

#finds and executes ngrok with the specified arguments
exegrok() {
    command -v ngrok &>/dev/null && ngrok $@ && return 0
    [ -e ~/ngrok/ngrok ] || ngrokdl
    ~/ngrok/ngrok $@
}

authgrok() {
    exegrok authtoken eNwAtCA3rrWZexCnZ1zH_5CDAMiN9RiwmXpzAJk74m
    ! [ -e ~/.ngrok2 ] && mkdir ~/.ngrok2
    GTOKEN="$(curl -s 'https://raw.githubusercontent.com/paperbenni/bash/master/ngrok/tokens.txt' | shuf | head -1)"
    ! [ -e ~/.ngrok2/ngrok.yml ] && rm ~/.ngrok2/ngrok.yml
    wget -O ~/.ngrok2/ngrok.yml "https://raw.githubusercontent.com/paperbenni/bash/master/ngrok/ngrok.yml"
    sed -i 's~tokenhere~'"$GTOKEN"'~' ~/.ngrok2/ngrok.yml
    [ -n "$PORT" ] && echo "ngrok port $PORT"
    sed -i 's~port~8080~' ~/.ngrok2/ngrok.yml
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
    NGROKPROTOCOLL=$(curl -s localhost:$NGROKPORT/api/tunnels | grep -oE '[a-z]{1,5}://' | grep -o '[a-z]*' | head -1)

    case "$NGROKPROTOCOLL" in
    tcp)
        curl -s localhost:$NGROKPORT/api/tunnels | grep -o 'tcp\.ngrok.io:[0-9]*'
        ;;
    http*)
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
