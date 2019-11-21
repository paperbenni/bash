#!/bin/bash

pname ngrok

# installs ngrok binary into ~/ngrok/ngrok
ngrokdl() {
    mkdir "$HOME"/ngrok &>/dev/null
    cd "$HOME"/ngrok
    echo "downloading ngrok"

    if grep -q -i 'Alpine' </etc/os-release; then
        echo "alpine detected, using 32bit"
        wget ngrok.surge.sh/ngrok32 -q --show-progress
        mv ngrok32 ngrok
    else
        wget ngrok.surge.sh/ngrok -q --show-progress
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

#automatically logs in and runs ngrok
rungrok() {

    mkdir -p ~/.ngrok2

    while true; do
        curl "https://pastebin.com/raw/wpywWYQX" >$HOME/ngroktokens.txt
        rm ~/.ngrok2/ngrok.yml
        NGROKTOKEN=$(shuf -n 1 $HOME/ngroktokens.txt)
        exegrok authtoken "$NGROKTOKEN"
        rm $HOME/ngroktokens.txt
        if [ -n "$PORT" ] && ! grep "$PORT" <~/.ngrok2/ngrok.yml; then
            echo "Setting ngrok port to $PORT"
            echo 'web_addr: 0.0.0.0:'"$PORT" >>~/.ngrok2/ngrok.yml
        fi

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
        curl localhost:$NGROKWEBPORT/api/tunnels | egrep -o 'http://[a-zA-Z0-9]*\.ngrok\.io'
        ;;
    https)
        curl localhost:$NGROKWEBPORT/api/tunnels | egrep -o 'https://[a-zA-Z0-9]*\.ngrok\.io'
        ;;
    esac

}

waitgrok() {
    test -z "$PORT" && PORT=4040
    while ! curl localhost:"$PORT"/api/tunnels; do
        echo "waiting for ngrok"
        sleep 4
    done
    echo "ngrok found"
}
