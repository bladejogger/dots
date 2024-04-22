#!/bin/bash

LOCKSCREEN=$(find ~/Pictures/lockscreens/ -type f | shuf -n1)
exec i3lock -i ${LOCKSCREEN}
