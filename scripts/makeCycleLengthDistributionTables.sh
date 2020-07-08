#!/bin/sh
#
# File:    makeCycleLengthDistriubutionTables.sh
# Author:  Alex Stivala
# Created: July 2019
#
# Run the CYPATH software to make tables of cycle and chordless cycle
# length distributions from sets of simulated networks,
# for reading in R and plotting etc.
# The simulated network are read from the directory where they were created
# with the  generateSimulatedNetworksFromStatnetModel.R script.
#
# Note that also cycle counting (in particular chordless cycles) uses the 
# CYPATH software from http://research.nii.ac.jp/~uno/code/cypath11.zip
# but have to edit the transgrh.pl script to add a semicolon on the end of line
# 38 as it does not work otherwise.
#
# Reference for CYPATH:
#
#    Uno, T., & Satoh, H. (2014, October). An efficient algorithm for
#    enumerating chordless cycles and chordless paths. In International
#    Conference on Discovery Science (pp. 313-324). Springer, Cham.
#
#
# Usage: makeCycleLengthDistriubutionTables.sh type inputdir
#
#    type is eiher c for cycle or C for chordless cycle (CYPATH option)
#    inputdir is directory containing simualted networks
#
# Output is to stdout.
#
#  e.g.: makeCycleLengthDistriubutionTables.sh C simulated/model1 > model1_chrodlesscycledisttable.txt
#

CYPATHDIR=${HOME}/CYPATH
PATH=${PATH}:${CYPATHDIR}

if [ $# -ne 2 ]; then
    echo "Usage: $0 c|C inputdir" >&2
    exit 1
fi
cypathopt=$1
inputdir=$2

echo "# Generated by: $0 $*"
echo "# At: " `date`
echo "# On: " `uname -a`

echo "sim length count" # header line: simulated network num, cycle len, count
for edgelistfile in ${inputdir}/sim_model*_*_edgelist.txt
do
    tmpfile=`mktemp`

    # format of each input edgelist file is e.g. sim_model1_95_edgelist.txt
    # so get number from filename
    num=`echo "${edgelistfile}" | sed 's/.*sim_model[0-9]*_\([0-9]*\)_edgelist.txt/\1/g'`

    # convert to format for CYPATH in tmpfile
    transgrh.pl < ${edgelistfile} > ${tmpfile}

    # run CYPATH to get cycle length distribution
    # each line n of output (after first) is number of cycles of len n 
    # starts at 0 (whiich is always 0) so skip that too (1 is also always 0 
    # but awk NR starts at 1 so easier to keep it)
    cypath ${cypathopt} ${tmpfile} | tail -n+3 | awk -v num=${num} '{print num,NR,$0}'

    rm ${tmpfile}
done
