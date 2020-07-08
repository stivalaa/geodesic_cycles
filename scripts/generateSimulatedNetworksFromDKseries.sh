#!/bin/sh
#
# File:    generateSimualtedNetworksFromDKseries.sh
# Author:  Alex Stivala
# Created: June 2020
#
# Generate simulated networks using the dk-series models from observed
# network using the RandNetGen program
# (https://github.com/polcolomer/RandNetGen downloaded 30 May 2020).
#
# Usage: generateSimulatedNetworksFromDKseries.sh dk edgelist.txt outdirname
#
#   dk           is the dk-series name passed to RandNetGen:
#                1, 2, 2.1, or 2.5 (see RandNetGen doc)
#   edgelist.txt is network in edge list format (undirected unweighted)
#   outdirname   is output directory (created if not existing). Output
#                files are written in that directory as:
#               sim_modelname_X_edgelist.txt
#                where modelname is the dk-series model (dk1,dk2,dk21,dk25)
#                  e.g. sim_modeldk21_32_edgelist.txt
#
#  Example:
#    generateSimulatedNetworksFromDKseries.sh 2.1 patricia1990_edgelist.txt simulated/dk21
#   
# Main references for dk-series are:
#
#  Orsini, C., Dankulov, M. M., Colomer-de-Simón, P., Jamakovic, A.,
#  Mahadevan, P., Vahdat, A., ... & Fortunato, S. (2015). Quantifying
#  randomness in real networks. Nature communications, 6(1), 1-10.
#
#  Mahadevan, P., Krioukov, D., Fall, K., & Vahdat,
#  A. (2006). Systematic topology analysis and generation using degree
#  correlations. ACM SIGCOMM Computer Communication Review, 36(4),
#  135-146.
#
# And references on github page for RanNetGen are:
#
# [1] Pol Colomer-de-Simón, M Angeles Serrano, Mariano Beiró,
# J. Ignacio Alvarez-Hamelin, and Marián Boguñá,
# “Deciphering the global organization of clustering in real
# complex networks.” Scientific reports 3, 2517 (2013).
#
# [2] Pol Colomer-de-Simón, Marián Boguñá, "Double Percolation
# Phase Transition in Clustered Complex Networks" Physical Review X,
# 4, 041020 (2014)
#
# [3] Chiara Orsini, Marija Mitrović Dankulov, Almerima Jamakovic,
# Priya Mahadevan, Pol Colomer-de-Simón, Amin Vahdat, Kevin
# E. Bassler, Zoltán Toroczkai, Marián Boguñá, Guido Caldarelli,
# Santo Fortunato, Dmitri Krioukov, "How Random are Complex Networks"
# Arxiv.org
#
# [4] P. Mahadevan, D. Krioukov, K. Fall, and A. Vahdat, Systematic
# Topology Analysis and Generation Using Degree Correlations SIGCOMM
# 2006
#


# number of simulated networks to generate
num_sim=100

RANDNETGEN=${HOME}/RandNetGen
PATH=${RANDNETGEN}:${PATH}

if [ $# -ne 3 ]; then
    echo "Usage: $0 dk edgelist outdir"
    exit 1
fi
dk=$1
edgelist=$2
outdir=$3

echo "Run as: $0 $*"
echo "At: " `date`
echo "On: " `uname -a`
echo "Generating ${num_sim} dk${dk} networks from ${edgelist} into ${outdir} ..."

if [ ! -d ${outdir} ]; then
    mkdir ${outdir}
fi

# RandNetGen only works if the input edgelist file is in the cwd, and the 
# output file is also written in the cwd so we have to copy the input file
# to the output dir and cd there to run everything.
# The output file is always <dk>_infilename e.g dk2.5_patricia1990_edgelist.txt
# so we have to rename each one to keep them all
# (note that for dk 1 and 2 the output name is dk1.0_ or dk2.0_ resp.)
# also writes E_vs_T.dat file for each one, but just ignore that and overwrite


cp ${edgelist} ${outdir}
netfile=`basename ${edgelist}`
cd ${outdir}
for i in `seq 1 ${num_sim}`
do
    # We must use -seed $RANDOM to get random seed as this often takes
    # less than 1 second to run and by default it seeds with time(NULL)
    # and hence get multiple runs with the same seed and hence identical 
    # output.
    RandNetGen -net $netfile -dk $dk -seed $RANDOM
    dkout=$dk
    if [ "$dk" = "1" ]; then
        dkout="1.0"
    elif [ "$dk" = "2" ]; then
        dkout="2.0"
    fi
    randnetgen_outfile="dk${dkout}_${netfile}"
    dk_no_period=`echo "${dk}" | sed 's/[.]//g'`
    # randNetGen outputs two rows for every edge i.e. both i j  and  j i
    # so filter to only include one for each edge by only including those
    # where i < j
    cat $randnetgen_outfile | awk '$1 < $2' > sim_modeldk${dk_no_period}_${i}_edgelist.txt
    rm $randnetgen_outfile
done
rm $netfile
times
echo "done."

