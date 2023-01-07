#!/bin/bash

#SBATCH --job-name="cypath_model1"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:10:00
#SBATCH --output=cypath_model1-%j.out
#SBATCH --error=cypath_model1-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts

ATOMICTAB=model1_atomiccycledisttable.txt
CHORDLESSTAB=model1_chordlesscycledisttable.txt
CYCLETAB=model1_cycledisttable.txt


OBS_ATOMICCYCLETAB=patricia1990_atomiccycletable.txt
OBS_CHORDLESSCYCLETAB=patricia1990_chordlesscycletable.txt
OBS_CYCLETAB=patricia1990_cycletable.txt

#
# generate tables using CYPATH or FindAtomicCycles
# (only run if not exist; so to regneraet remove these files first)
#
if [ ! -f $ATOMICTAB ]; then 
	time $SCRIPTDIR/makeAtomicCycleLengthDistributionTables.sh simulated/model1/ > ${ATOMICTAB}
fi

if [ ! -f $CHORDLESSTAB ]; then 
	time $SCRIPTDIR/makeCycleLengthDistributionTables.sh C simulated/model1/ > ${CHORDLESSTAB}
fi

if [ ! -f $CYCLETAB ]; then 
	time $SCRIPTDIR/makeCycleLengthDistributionTables.sh c simulated/model1 > ${CYCLETAB}
fi

if [ ! -f $OBS_ATOMICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkAtomicCycleLengthDistributionTable.sh patricia1990_edgelist.txt > ${OBS_ATOMICCYCLETAB}
fi

if [ ! -f $OBS_CHORDLESSCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkCycleLengthDistributionTable.sh C patricia1990_edgelist.txt > ${OBS_CHORDLESSCYCLETAB}
fi

if [ ! -f $OBS_CYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkCycleLengthDistributionTable.sh c patricia1990_edgelist.txt > ${OBS_CYCLETAB}
fi

#
# generate plots from tables with R
#
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R ERGM 'geodesic cycle'  ${ATOMICTAB} ${OBS_ATOMICCYCLETAB}

time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R  ERGM 'chordless cycle'  ${CHORDLESSTAB} ${OBS_CHORDLESSCYCLETAB}

time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R ERGM 'cycle'  ${CYCLETAB} ${OBS_CYCLETAB}

echo Ended at `date` 
