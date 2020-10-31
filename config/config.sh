#!/usr/bin/env bash
pname config/config

# used for spigot options
confset() {

    if [ -z "$3" ]; then
        echo "usage: confset file option value"
    fi

    if grep -q "^$2" "$1"
    then
        sed -i "/^$2=/c $2=$3" "$1"
    else
        echo "$2=$3" >> "$1"
    fi

    grep "$2" <"$1"
}

# get value from format key:value without a preceding space
# if not found return $3
# optional delimiter $4, default :
confget() {
    # File and key required.
    { [ -z "$1" ] || [ -z "$2" ]; } && return 1

    # File must exist, be a file, and have read access.
    if { [ -f "$1" ] && [ -r "$1" ]; }; then
        [ -n "$3" ] || return 2
        echo "$3" && return 0
    fi

    while IFS="${4:-:}" read -a ARRAY; do
        if [ "${ARRAY[0]}" = "$2" ]; then
            # Use extended globbing to match any number of spaces.
            shopt -s extglob
            echo "${ARRAY[1]##+([[:space:]])}"
            shopt -u extglob

            return 0
        fi
    done <"$1"

    # return default value if value is not set in the file
    [ -n "$3" ] && echo "$3"
}
