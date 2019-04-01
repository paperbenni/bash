#!/usr/bin/env bash

# emulates sudo on non-sudo systems like docker containers
# so that bash scripts containing sudo can be run without modifications

sudo() {

    for argument in "$@"; do
        if echo "$argument" | grep -q -w '\-.*'; then
            shift
        else
            echo "running $argument"
            break
        fi
    done
    eval "$@"

}
