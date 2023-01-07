#!/bin/bash

#SBATCH --job-name="atomic_dkseries"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:40:00
#SBATCH --output=atomic_dkseries-%j.out
#SBATCH --error=atomic_dkseries-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts



OBS_ATOMICCYCLETAB=lazega_lawfirm_friendship_atomiccycletable.txt

#
# generate tables using  FindAtomicCycles
# (only run if not exist; so to regneraet remove these files first)
#

if [ ! -f $OBS_ATOMICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkAtomicCycleLengthDistributionTable.sh lazega_lawfirm_friendship_edgelist.txt > ${OBS_ATOMICCYCLETAB}
fi


for dk in 0 1 2 21 25
do
    ATOMICTAB=dk${dk}_atomiccycledisttable.txt
    if [ ! -f $ATOMICTAB ]; then 
    	time $SCRIPTDIR/makeAtomicCycleLengthDistributionTables.sh simulated/dk${dk}/ > ${ATOMICTAB}
    fi
    # generate plots from tables with R
    dktitle=`echo $dk | sed 's/21/2.1/;s/25/2.5/'`
    time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R "dk-series $dktitle k" 'geodesic cycle'  ${ATOMICTAB} ${OBS_ATOMICCYCLETAB}
done


echo Ended at `date` 
