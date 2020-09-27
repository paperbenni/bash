#!/bin/bash
pname grep/sed

# remove all lines between and including two markers ($2 and $3)
removebetween() {
    RMBEGIN=${2:-\#paperbegin}
    RMEND=${3:-\#paperend}
    if grep "$RMBEGIN" <"$1" && grep "$RMEND" <"$1"; then
        sed -i "/$RMBEGIN/,/$RMEND/d" "$1"
    else
        echo "markers not found"
        return 1
    fi
}

# append $2 to $1 and enclose it between markers
appendmarkers() {
    RMBEGIN=${3:-\#paperbegin}
    RMEND=${4:-\#paperend}
    if grep "$RMBEGIN" <"$1" || grep "$RMEND" <"$1"; then
        echo "markers already found"
        return 1
    fi

    echo "$RMBEGIN" | tee -a "$1" &>/dev/null
    echo "$2" | tee -a "$1" &>/dev/null
    echo "$RMEND" | tee -a "$1" &>/dev/null

}
