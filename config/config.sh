#!/usr/bin/env bash
pname config/config

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
    [ -z "$2" ] && return 1
    if [ -e "$1" ] && grep -i -q "$2" <"$1"; then
        DELIMITER=${4:-:}
        VALUE=$(grep "^$2$DELIMITER" <"$1" |
            grep -o "$DELIMITER"'.*')
        echo "${VALUE##$DELIMITER}"
    else
        # return default value if value is not set in the file
        if [ -n "$3" ]; then
            echo "$3"
        else
            return 1
        fi
    fi
}
