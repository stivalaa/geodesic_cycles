#!/bin/sh
#
# File:    renameEffectsStatnetPatricia.sh
# Author:  Alex Stivala
# Created: August 2019
#
# Rename the effects in LaTeX table to specific names used in delusional
# social network statnet estimations.
#
# Input is stdin, output is stdout.
#
# Usage: renameEffectsStatnetPatricia.sh < infile > outfile
#

if [ $# -ne 0 ]; then
    echo "Usage: $0 < in > out" >&2
    exit 1
fi

sed 's/edges/Edges/g;s/gwdsp/GWDSP/g;s/[.]decay/ decay/g;s/gwesp.fixed.0/GWESP/g;s/absdiff[.]\([a-z]*\)/\1 - Heterophily/g;s/degree\([0-9]*\)/Degree \1/g;s/deg\([0-9]*\)to\([0-9]*\)/Degree \1 -- \2/g;s/gwDegree/GWDEGREE/g;s/nodefactor[.]\([A-Za-z]*\)[.]1/Activity \1/g;s/nodematch[.]\([A-Za-z]*\)/Homophily \1/g;s/christian/Christian/g;s/integrated/Integrated/g;s/sphere/Sphere/g;s/behind/Behind/g'

