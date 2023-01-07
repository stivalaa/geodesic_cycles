#!/bin/bash

#SBATCH --job-name="geodesic_dkseries"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:40:00
#SBATCH --output=geodesic_dkseries-%j.out
#SBATCH --error=geodesic_dkseries-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts

module load r

OBS_GEODESICCYCLETAB=patricia1992_geodesiccycletable.txt

#
# generate tables using CYPATH and filterCyclesGeodesic.R
# (only run if not exist; so to regneraet remove these files first)
#

if [ ! -f $OBS_GEODESICCYCLETAB ]; then 
	time $SCRIPTDIR/makeSingleNetworkGeodesicCycleLengthDistributionTable.sh patricia1992_edgelist.txt > ${OBS_GEODESICCYCLETAB}
fi


for dk in 0 1 2 21 25
do
    GEODESICTAB=dk${dk}_geodesiccycledisttable.txt
    if [ ! -f $GEODESICTAB ]; then 
    	time $SCRIPTDIR/makeGeodesicCycleLengthDistributionTables.sh simulated/dk${dk}/ > ${GEODESICTAB}
    fi
    # generate plots from tables with R
    dktitle=`echo $dk | sed 's/21/2.1/;s/25/2.5/'`
    time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R "dk-series $dktitle k" 'geodesic cycle'  ${GEODESICTAB} ${OBS_GEODESICCYCLETAB}
done


echo Ended at `date` 
