#!/bin/bash

pname ngrok

# installs ngrok binary into ~/ngrok/ngrok
ngrokdl() {
    mkdir "$HOME"/ngrok &>/dev/null
    cd "$HOME"/ngrok
    echo "downloading ngrok"

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
    if ngrok --version &>/dev/null; then
        ngrok "$@"
    else
        if ! ~/ngrok/ngrok --version &>/dev/null; then
            ngrokdl
        fi
        ~/ngrok/ngrok "$@"
    fi
}

authgrok() {
    ! [ -e ~/.ngrok2 ] && mkdir ~/.ngrok2
    GTOKEN="$(curl -s 'https://raw.githubusercontent.com/paperbenni/bash/master/ngrok/tokens.txt' | shuf | head -1)"
    ! [ -e ~/.ngrok2/ngrok.yml ] && rm ~/.ngrok2/ngrok.yml
    wget -O ~/.ngrok2/ngrok.yml "https://raw.githubusercontent.com/paperbenni/bash/master/ngrok/ngrok.yml"
    sed -i 's~tokenhere~'"$GTOKEN"'~' ~/.ngrok2/ngrok.yml
    [ -n "$PORT" ] && echo "ngrok port $PORT"
    sed -i 's~port~'"${PORT:-8080}"'~' ~/.ngrok2/ngrok.yml
}

#automatically logs in and runs ngrok
rungrok() {

    mkdir -p ~/.ngrok2

    while true; do
        authgrok
        sleep 2
        exegrok "$@"
        sleep 5
    done

}

#gets your ngrok adress into stdout
getgrok() {
    NGROKPROTOCOLL="${1:-tcp}"
    NGROKWEBPORT=4040
    echoerr "trying 4040"
    if ! curl localhost:4040; then
        echoerr "switching ngrok to 8080"
        NGROKWEBPORT=8080
    fi

    curl localhost:$NGROKWEBPORT &>/dev/null || (echoerr "web interface not found, exiting" && return 1)
    case "$NGROKPROTOCOLL" in
    tcp)
        curl localhost:$NGROKWEBPORT/api/tunnels | grep 'ngrok' | grep -oP 'tcp://.*?:[0-9]*'
        ;;
    http)
        curl localhost:$NGROKWEBPORT/api/tunnels | grep -Eo 'http://[a-zA-Z0-9]*\.ngrok\.io'
        ;;
    https)
        curl localhost:$NGROKWEBPORT/api/tunnels | grep -Eo 'https://[a-zA-Z0-9]*\.ngrok\.io'
        ;;
    esac

}

waitgrok() {
    while ! curl "localhost:${PORT:-4040}/api/tunnels"; do
        echo "waiting for ngrok"
        sleep 4
    done
    echo "ngrok found"
}
