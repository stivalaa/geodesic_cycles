#!/bin/bash

#SBATCH --job-name="atomic_chordless_cypath_model2"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-23:40:00
#SBATCH --output=atomic_chordless_cypath_model2-%j.out
#SBATCH --error=atomic_chordless_cypath_model2-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts

ATOMICTAB=model2_atomiccycledisttable.txt
CHORDLESSTAB=model2_chordlesscycledisttable.txt


OBS_ATOMICCYCLETAB=highschoolfriendship_atomiccycletable.txt
OBS_CHORDLESSCYCLETAB=highschoolfriendship_chordlesscycletable.txt

#
# generate tables using CYPATH or FindAtomicCycles
# (only run if not exist; so to regneraet remove these files first)
#

if [ ! -f $OBS_ATOMICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkAtomicCycleLengthDistributionTable.sh highschoolfriendship_edgelist.txt > ${OBS_ATOMICCYCLETAB}
fi

if [ ! -f $OBS_CHORDLESSCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkCycleLengthDistributionTable.sh C highschoolfriendship_edgelist.txt > ${OBS_CHORDLESSCYCLETAB}
fi


if [ ! -f $ATOMICTAB ]; then 
	time $SCRIPTDIR/makeAtomicCycleLengthDistributionTables.sh simulated/model2/ > ${ATOMICTAB}
fi

if [ ! -f $CHORDLESSTAB ]; then 
	time $SCRIPTDIR/makeCycleLengthDistributionTables.sh C simulated/model2/ > ${CHORDLESSTAB}
fi


#
# generate plots from tables with R
#
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${ATOMICTAB} ${OBS_ATOMICCYCLETAB}

time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'chordless cycle'  ${CHORDLESSTAB} ${OBS_CHORDLESSCYCLETAB}


echo Ended at `date` 
