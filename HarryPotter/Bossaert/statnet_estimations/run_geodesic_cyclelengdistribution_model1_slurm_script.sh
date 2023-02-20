#!/bin/bash

#SBATCH --job-name="geodesic_model1"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-00:20:00
#SBATCH --output=geodesic_model1-%j.out
#SBATCH --error=geodesic_model1-%j.err

uname -a
echo Started at `date`

module purge

SCRIPTDIR=../../../scripts

GEODESICTAB=model1_geodesiccycledisttable.txt


OBS_GEODESICCYCLETAB=harrypotter_geodesiccycletable.txt

#
# generate tables using CYPATH and filterCyclesGeodesic.R
# (only run if not exist; so to regenerate remove these files first)
#

if [ ! -f $OBS_GEODESICCYCLETAB ]; then 
        module load python/3.9.0
	time $SCRIPTDIR/makeSingleNetworkGeodesicCycleLengthDistributionTable.sh ../dkseries/harrypotter_edgelist.txt > ${OBS_GEODESICCYCLETAB}
fi


if [ ! -f $GEODESICTAB ]; then 
        module load python/3.9.0
	time $SCRIPTDIR/makeGeodesicCycleLengthDistributionTables.sh simulated/model1/ > ${GEODESICTAB}
fi


#
# generate plots from tables with R
#
module purge
module load r
time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${GEODESICTAB} ${OBS_GEODESICCYCLETAB}


echo Ended at `date` 
