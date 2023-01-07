#!/bin/bash

#SBATCH --job-name="cypath_model4"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:10:00
#SBATCH --output=cypath_model4-%j.out
#SBATCH --error=cypath_model4-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts

ATOMICTAB=model4_atomiccycledisttable.txt
CHORDLESSTAB=model4_chordlesscycledisttable.txt
CYCLETAB=model4_cycledisttable.txt


OBS_ATOMICCYCLETAB=patricia1993_atomiccycletable.txt
OBS_CHORDLESSCYCLETAB=patricia1993_chordlesscycletable.txt
OBS_CYCLETAB=patricia1993_cycletable.txt

#
# generate tables using CYPATH or FindAtomicCycles
# (only run if not exist; so to regneraet remove these files first)
#
if [ ! -f $ATOMICTAB ]; then 
	time $SCRIPTDIR/makeAtomicCycleLengthDistributionTables.sh simulated/model4/ > ${ATOMICTAB}
fi

if [ ! -f $CHORDLESSTAB ]; then 
	time $SCRIPTDIR/makeCycleLengthDistributionTables.sh C simulated/model4/ > ${CHORDLESSTAB}
fi

if [ ! -f $CYCLETAB ]; then 
	time $SCRIPTDIR/makeCycleLengthDistributionTables.sh c simulated/model4 > ${CYCLETAB}
fi

if [ ! -f $OBS_ATOMICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkAtomicCycleLengthDistributionTable.sh patricia1993_edgelist.txt > ${OBS_ATOMICCYCLETAB}
fi

if [ ! -f $OBS_CHORDLESSCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkCycleLengthDistributionTable.sh C patricia1993_edgelist.txt > ${OBS_CHORDLESSCYCLETAB}
fi

if [ ! -f $OBS_CYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkCycleLengthDistributionTable.sh c patricia1993_edgelist.txt > ${OBS_CYCLETAB}
fi

#
# generate plots from tables with R
#
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${ATOMICTAB} ${OBS_ATOMICCYCLETAB}

time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'chordless cycle'  ${CHORDLESSTAB} ${OBS_CHORDLESSCYCLETAB}

time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'cycle'  ${CYCLETAB} ${OBS_CYCLETAB}

echo Ended at `date` 
