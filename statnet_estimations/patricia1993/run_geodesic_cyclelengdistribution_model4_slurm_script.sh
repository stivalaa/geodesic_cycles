#!/bin/bash

#SBATCH --job-name="geodesic_model4"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-1:00:00
#SBATCH --output=geodesic_model4-%j.out
#SBATCH --error=geodesic_model4-%j.err

uname -a
echo Started at `date`

module purge # otherwise module load python and r can fail
module load python/3.9.0 # needed for filterCyclesGeodesic.py in scripts

SCRIPTDIR=../../scripts

GEODESICTAB=model4_geodesiccycledisttable.txt


OBS_GEODESICCYCLETAB=patricia1993_geodesiccycletable.txt

#
# generate tables using CYPATH and filterCyclesGeodesic.R
# (only run if not exist; so to regneraet remove these files first)
#
if [ ! -f $GEODESICTAB ]; then 
	time $SCRIPTDIR/makeGeodesicCycleLengthDistributionTables.sh simulated/model4/ > ${GEODESICTAB}
fi


if [ ! -f $OBS_GEODESICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkGeodesicCycleLengthDistributionTable.sh patricia1993_edgelist.txt > ${OBS_GEODESICCYCLETAB}
fi


module purge #otherwise module load r fails
module load r
#
# generate plots from tables with R
#
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${GEODESICTAB} ${OBS_GEODESICCYCLETAB}


echo Ended at `date` 
