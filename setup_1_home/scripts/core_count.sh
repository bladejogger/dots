#!/bin/bash

# logical cores
lscpu -p | egrep -v '^#' | wc -l

# physical cores
lscpu -p | egrep -v '^#' | sort -u -t, -k 2,4 | wc -l
