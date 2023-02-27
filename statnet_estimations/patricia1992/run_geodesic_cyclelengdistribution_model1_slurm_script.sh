#!/bin/bash

#SBATCH --job-name="geodesic_model1"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-1:00:00
#SBATCH --output=geodesic_model1-%j.out
#SBATCH --error=geodesic_model1-%j.err

uname -a
echo Started at `date`

module purge
module load python/3.9.0

SCRIPTDIR=../../scripts

GEODESICTAB=model1_geodesiccycledisttable.txt


OBS_GEODESICCYCLETAB=patricia1992_geodesiccycletable.txt

#
# generate tables using CYPATH and filterCyclesGeodesic.R
# (only run if not exist; so to regneraet remove these files first)
#
if [ ! -f $GEODESICTAB ]; then 
	time $SCRIPTDIR/makeGeodesicCycleLengthDistributionTables.sh simulated/model1/ > ${GEODESICTAB}
fi


if [ ! -f $OBS_GEODESICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkGeodesicCycleLengthDistributionTable.sh patricia1992_edgelist.txt > ${OBS_GEODESICCYCLETAB}
fi


#
# generate plots from tables with R
#
module unload python # otherwise module load r fails
module load r
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${GEODESICTAB} ${OBS_GEODESICCYCLETAB}


echo Ended at `date` 
