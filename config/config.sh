#!/usr/bin/env bash
#pname config/config

# used for spigot options
function confset() {
    if ! [ -e "$1" ]; then
        echo "target config file '$1' not existing!" >&2
        return 1
    fi
    if [ -z "$3" ]; then
        echo "usage: confset file option value"
    fi
    if [[ "$1" == *"$2=$3"* ]]; then
        echo "value $2=$3 already set"
        return 0
    else
        echo "setting $2=$3"
    fi
    NEWVALUE="$2=$3"
    sed -i "/^$2=/c $NEWVALUE" "$1"
    grep "$2" <"$1"
}

# get value from format key:value without a preceding space
# if not found return $3
# optional delimiter $4, default :
function confget() {
    # File and key required.
    [ -z "$1" -o -z "$2" ] && return 1

    while IFS="${4:-:}" read -a ARRAY; do
        if [ "${ARRAY[0]}" == "$2" ]; then
            echo "${ARRAY[1]}"
            return 0
        fi
    done < "$1"

    # return default value if value is not set in the file
    [ -n "$3" ] && echo "$3"
}
