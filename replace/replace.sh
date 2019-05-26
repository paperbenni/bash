#!/usr/bin/env bash
pname replace/replace
# removes the last line from a file
rmlast() {
    RMTIMES="${2:-1}"
    for i in $(seq $RMTIMES); do
        head -n -1 "$1" >tempfoo.txt
        mv tempfoo.txt "$1"
    done
}

# removes the first line from a file
rmfirst() {
    RMTIMES="${2:-1}"
    for i in $(seq $RMTIMES); do
        tail -n +2 "$1" >tempfirst.txt
        mv tempfirst.txt "$1"
    done
}

# appends to the beginning of a file
preappend() {
    echo -e "$1\n$(cat $2)" >$2
}

# replaces $1 with $2 in file $3
rpstring() {
    if echo "$1$2" | egrep '[/~]'; then
        sed -i -e "s/$1/$2/g" $3
    else
        sed -i -e "s#$1#$2#g" $3
    fi
}

rmstring() {
    sed -i '/'"$1"'/d' ./"$2"
}

insertat() {
    sed -i -e "/$1/a $2" $3
    sed -i '/removeme/d' "$3"
}
