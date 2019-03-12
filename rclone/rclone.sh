#!/usr/bin/env bash
rdl() {
    if [ -z "$2" ]; then
        rclone copy "$RCLOUD":"$RNAME"/"$1"
    else
        rclone copy "$RCLOUD":"$RNAME"/"$1" ./"$2"
    fi
}

rupl() {
    if [ -z "$2" ]; then
        rclone copy "$1" "$RCLOUD":"$RNAME"/"$1"
    else
        rclone copy "$1" "$RCLOUD":"$RNAME"/"$2"/"$1"
    fi
}

rappend() {
    if ! [ -e "$HOME"/.config/rclone/rclone.conf ]; then
        mkdir -p "$HOME/.config/rclone"
    fi
    pushd "$HOME/.config/rclone" || return 1
    echo "$1" >>rclone.conf
}

rmega() {
    if [ -z "$3" ]; then
        APPENDCLOUD="mega"
    else
        APPENDCLOUD="$3"
    fi

    if (cat "$HOME/.config/rclone/rclone.conf" | grep "$1"); then
        echo "remote name already existing"
        return
    fi
    rappend "[$APPENDCLOUD]"
    rappend "type = mega"
    rappend "user = $1"
    rappend "pass = $2"

}
