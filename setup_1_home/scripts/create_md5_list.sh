#!/bin/bash

# $# = num cmdline args
if [ $# -eq 1 ]; then
    DIR=$1
else
    DIR=.
fi

find "$DIR" -type f -exec md5sum '{}' \;
