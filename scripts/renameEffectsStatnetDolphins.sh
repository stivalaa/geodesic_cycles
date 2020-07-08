#!/bin/sh
#
# File:    renameEffectsStatnetDolphins.sh
# Author:  Alex Stivala
# Created: August 2019
#
# Rename the effects in LaTeX table to specific names used in delusional
# social network statnet estimations.
#
# Input is stdin, output is stdout.
#
# Usage: renameEffectsStatnetDolphins.sh < infile > outfile
#

if [ $# -ne 0 ]; then
    echo "Usage: $0 < in > out" >&2
    exit 1
fi

sed 's/edges/Edges/g;s/gwdsp/GWDSP/g;s/gwesp/GWESP/g;s/[.]decay/ decay/g;s/gwdegree/GWDEGREE/g;s/[.]alpha/ $\\alpha$/g;s/\([A-Z]*\)[.]fixed[.]\([0-9.]*\)/\1 ($\\alpha = \2$)/g;'

