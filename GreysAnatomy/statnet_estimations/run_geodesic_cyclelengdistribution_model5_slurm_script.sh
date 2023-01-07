#!/bin/bash

#SBATCH --job-name="geodesic_model5"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-1:00:00
#SBATCH --output=geodesic_model5-%j.out
#SBATCH --error=geodesic_model5-%j.err

uname -a
echo Started at `date`

module load r

SCRIPTDIR=../../scripts

GEODESICTAB=model5_geodesiccycledisttable.txt


OBS_GEODESICCYCLETAB=greysanatomy_geodesiccycletable.txt

#
# generate tables using CYPATH and filterCyclesGeodesic.R
# (only run if not exist; so to regneraet remove these files first)
#
if [ ! -f $GEODESICTAB ]; then 
	time $SCRIPTDIR/makeGeodesicCycleLengthDistributionTables.sh simulated/model5/ > ${GEODESICTAB}
fi


if [ ! -f $OBS_GEODESICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkGeodesicCycleLengthDistributionTable.sh greysanatomy_edgelist.txt > ${OBS_GEODESICCYCLETAB}
fi


#
# generate plots from tables with R
#
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${GEODESICTAB} ${OBS_GEODESICCYCLETAB}


echo Ended at `date` 
