#!/usr/bin/env bash
LAUNCHDIR=pastedirhere
if ! [ -e "$LAUNCHDIR/$1.sh" ]; then
    echo "file $1 not found"
else
    EXESCRIPT="$1"
    shift
    "$LAUNCHDIR/$EXESCRIPT" "$@"
fi
