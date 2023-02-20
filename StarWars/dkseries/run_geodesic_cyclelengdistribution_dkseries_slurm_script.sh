#!/bin/bash

#SBATCH --job-name="geodesic_dkseries"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=2GB
#SBATCH --time=0-48:00:00
#SBATCH --output=geodesic_dkseries-%j.out
#SBATCH --error=geodesic_dkseries-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts

module purge

OBS_GEODESICCYCLETAB=starwars_geodesiccycletable.txt

#
# generate tables using CYPATH and filterCyclesGeodesic.py
# (only run if not exist; so to regenerate remove these files first)
#

if [ ! -f $OBS_GEODESICCYCLETAB ]; then 
        module load python/3.9.0  # needed for filterCycleGeodesic.py in script
	time $SCRIPTDIR/makeSingleNetworkGeodesicCycleLengthDistributionTable.sh starwars_edgelist.txt > ${OBS_GEODESICCYCLETAB}
fi

# make table for one dk-series model
# Parameter: dk number (0,1,2,21,25)
run_geodesic_dk() {
    dk=$1
    GEODESICTAB=dk${dk}_geodesiccycledisttable.txt
    if [ ! -f $GEODESICTAB ]; then 
        module load python/3.9.0  # needed for filterCycleGeodesic.py in script
    	time $SCRIPTDIR/makeGeodesicCycleLengthDistributionTables.sh simulated/dk${dk}/ > ${GEODESICTAB}
    fi
    # generate plots from tables with R
    module unload python # otherwise module load r fails sometimes
    module load r
    dktitle=`echo $dk | sed 's/21/2.1/;s/25/2.5/'`
    time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R "dk-series $dktitle k" 'geodesic cycle'  ${GEODESICTAB} ${OBS_GEODESICCYCLETAB}
}

for dk in 0 1 2 21 25
do
  run_geodesic_dk ${dk} &
done
wait

echo Ended at `date` 
