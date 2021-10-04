#!/bin/sh
#
# File:    renameEffectsStatnetHighSchoolFriendship.sh
# Author:  Alex Stivala
# Created: August 2019
#
# Rename the effects in LaTeX table to specific names used high school 
# friendship network.
#
# Input is stdin, output is stdout.
#
# Usage: renameEffectsStatnetHighSchoolFriendship.sh < infile > outfile
#

if [ $# -ne 0 ]; then
    echo "Usage: $0 < in > out" >&2
    exit 1
fi

sed 's/edges/Edges/g;s/[.]decay/ decay/g;s/gwesp.fixed.\([0-9.]*\)/GWESP ($\\alpha = \1$)/g;s/gwdsp.fixed.\([0-9.]*\)/GWDSP ($\\alpha = \1$)/g;s/absdiff[.]\([a-z]*\)/Heterophily \1/g;s/gwodegree/GW out-degree/g;s/gwidegree/GW in-degree/g;s/nodefactor[.]\([A-Za-z]*\)[.]1/Activity \1/g;s/nodematch[.]\([A-Za-z]*\)/Homophily \1/g;s/mix[.]position[.]\([A-Za-z-]*\)[.]\([A-Za-z-]*\)/\1 -- \2/g;s/mutual[.]\([A-Za-z]*\)/Reciprocity \1/g;s/sex/Sex/g;s/[.]alpha/ $\\alpha$/g;s/gwesp/GWESP/g;s/class/Class/g;s/mutual/Reciprocity/g'

