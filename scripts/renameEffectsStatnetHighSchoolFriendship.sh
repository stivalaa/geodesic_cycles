#!/bin/sh
#
# File:    renameEffectsStatnetGreysAnatomy.sh
# Author:  Alex Stivala
# Created: August 2019
#
# Rename the effects in LaTeX table to specific names used in Grey's Anatomy
# sexual network estimations.
#
# Input is stdin, output is stdout.
#
# Usage: renameEffectsStatnetGreysAnatomy.sh < infile > outfile
#

if [ $# -ne 0 ]; then
    echo "Usage: $0 < in > out" >&2
    exit 1
fi

sed 's/edges/Edges/g;s/[.]decay/ decay/g;s/gwesp.fixed.\([0-9.]*\)/GWESP ($\\alpha = \1$)/g;s/gwdsp.fixed.\([0-9.]*\)/GWDSP ($\\alpha = \1$)/g;s/absdiff[.]\([a-z]*\)/Heterophily \1/g;s/degree\([0-9]*\)/Degree \1/g;s/deg\([0-9]*\)to\([0-9]*\)/Degree \1 -- \2/g;s/gwDegree/GWDEGREE/g;s/nodefactor[.]\([A-Za-z]*\)[.]1/Activity \1/g;s/nodematch[.]\([A-Za-z]*\)/Homophily \1/g;s/mix[.]position[.]\([A-Za-z-]*\)[.]\([A-Za-z-]*\)/\1 -- \2/g;s/sex/Sex/g;s/[.]alpha/ $\\alpha$/g;s/gwesp/GWESP/g;s/class/Class/g'

