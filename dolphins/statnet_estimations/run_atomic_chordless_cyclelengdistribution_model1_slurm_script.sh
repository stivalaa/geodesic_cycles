#!/bin/bash

#SBATCH --job-name="atmoic_chordless_cypath_model1"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:40:00
#SBATCH --output=atomic_chordless_cypath_model1-%j.out
#SBATCH --error=atomic_chordless_cypath_model1-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts

ATOMICTAB=model1_atomiccycledisttable.txt
CHORDLESSTAB=model1_chordlesscycledisttable.txt


OBS_ATOMICCYCLETAB=dolphins_atomiccycletable.txt
OBS_CHORDLESSCYCLETAB=dolphins_chordlesscycletable.txt

#
# generate tables using CYPATH or FindAtomicCycles
# (only run if not exist; so to regneraet remove these files first)
#

if [ ! -f $OBS_ATOMICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkAtomicCycleLengthDistributionTable.sh dolphins_edgelist.txt > ${OBS_ATOMICCYCLETAB}
fi

if [ ! -f $OBS_CHORDLESSCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkCycleLengthDistributionTable.sh C dolphins_edgelist.txt > ${OBS_CHORDLESSCYCLETAB}
fi


if [ ! -f $ATOMICTAB ]; then 
	time $SCRIPTDIR/makeAtomicCycleLengthDistributionTables.sh simulated/model1/ > ${ATOMICTAB}
fi

if [ ! -f $CHORDLESSTAB ]; then 
	time $SCRIPTDIR/makeCycleLengthDistributionTables.sh C simulated/model1/ > ${CHORDLESSTAB}
fi


#
# generate plots from tables with R
#
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${ATOMICTAB} ${OBS_ATOMICCYCLETAB}

time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'chordless cycle'  ${CHORDLESSTAB} ${OBS_CHORDLESSCYCLETAB}


echo Ended at `date` 
