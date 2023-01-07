#!/bin/bash

#SBATCH --job-name="atomic_model3"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:40:00
#SBATCH --output=atomic_model3-%j.out
#SBATCH --error=atomic_model3-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts

ATOMICTAB=model3_atomiccycledisttable.txt


OBS_ATOMICCYCLETAB=highschoolfriendship_atomiccycletable.txt

#
# generate tables using  FindAtomicCycles
# (only run if not exist; so to regneraet remove these files first)
#

if [ ! -f $OBS_ATOMICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkAtomicCycleLengthDistributionTable.sh highschoolfriendship_edgelist.txt > ${OBS_ATOMICCYCLETAB}
fi


if [ ! -f $ATOMICTAB ]; then 
	time $SCRIPTDIR/makeAtomicCycleLengthDistributionTables.sh simulated/model3/ > ${ATOMICTAB}
fi



#
# generate plots from tables with R
#
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${ATOMICTAB} ${OBS_ATOMICCYCLETAB}



echo Ended at `date` 
