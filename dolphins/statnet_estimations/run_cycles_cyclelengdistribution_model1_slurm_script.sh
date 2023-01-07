#!/bin/bash

#SBATCH --job-name="cycles_cypath_model1"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-6:10:00
#SBATCH --output=cypath_cycles_model1-%j.out
#SBATCH --error=cypath_cycles_model1-%j.err

# separate this from atomic and chrodless cycles as
# this can be very slow due to huge numbers of cycles, others not so much

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts

CYCLETAB=model1_cycledisttable.txt


OBS_CYCLETAB=dolphins_cycletable.txt

#
# generate tables using CYPATH or FindAtomicCycles
# (only run if not exist; so to regneraet remove these files first)
#

if [ ! -f $OBS_CYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkCycleLengthDistributionTable.sh c dolphins_edgelist.txt > ${OBS_CYCLETAB}
fi

if [ ! -f $CYCLETAB ]; then 
	time $SCRIPTDIR/makeCycleLengthDistributionTables.sh c simulated/model1 > ${CYCLETAB}
fi

#
# generate plots from tables with R
#

time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'cycle'  ${CYCLETAB} ${OBS_CYCLETAB}

echo Ended at `date` 
