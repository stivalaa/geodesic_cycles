#!/bin/sh
#
# File:    renameEffectsStatnetZacharyKarateclub.sh
# Author:  Alex Stivala
# Created: August 2019
#
# Rename the effects in LaTeX table to specific names used in Zachary karate
# club social network estimations.
#
# Input is stdin, output is stdout.
#
# Usage: renameEffectsStatnetZacharyKarateclub.sh < infile > outfile
#

if [ $# -ne 0 ]; then
    echo "Usage: $0 < in > out" >&2
    exit 1
fi

sed 's/edges/Edges/g;s/gwdsp/GWDSP/g;s/[.]decay/ decay/g;s/gwDegree/GWDEGREE/g;s/nodefactor[.]\([A-Za-z]*\)[.]1/Activity \1/g;s/nodematch[.]\([A-Za-z]*\)/Homophily \1/g;s/gwesp/GWESP/g;s/gwdegree/GWDEGREE/g;s/absdiff[.]faction[.]id[.]\([1-4]\)/Faction abs. diff. \1/g;s/nodefactor[.]role[.]\([A-Za-z]*\)/\1/g;s/\([A-Z]*\)[.]fixed[.]\([0-9.]*\)/\1 ($\\alpha = \2$)/g;'

