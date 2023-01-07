#!/bin/bash

#SBATCH --job-name="geodesic_model1"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-40:00:00
#SBATCH --output=geodesic_model1-%j.out
#SBATCH --error=geodesic_model1-%j.err

uname -a
echo Started at `date`

module load r

SCRIPTDIR=../../scripts

GEODESICTAB=model1_geodesiccycledisttable.txt


OBS_GEODESICCYCLETAB=dolphins_geodesiccycletable.txt

#
# generate tables using CYPATH and filterCyclesGeodesic.R
# (only run if not exist; so to regenerate remove these files first)
#

if [ ! -f $OBS_GEODESICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkGeodesicCycleLengthDistributionTable.sh dolphins_edgelist.txt > ${OBS_GEODESICCYCLETAB}
fi


if [ ! -f $GEODESICTAB ]; then 
	time $SCRIPTDIR/makeGeodesicCycleLengthDistributionTables.sh simulated/model1/ > ${GEODESICTAB}
fi


#
# generate plots from tables with R
#
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${GEODESICTAB} ${OBS_GEODESICCYCLETAB}


echo Ended at `date` 
