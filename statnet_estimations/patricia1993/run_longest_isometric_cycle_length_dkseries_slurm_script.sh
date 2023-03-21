#!/bin/bash

#SBATCH --job-name="longest_isometric_dkeseries"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=2GB
#SBATCH --time=0-2:00:00
#SBATCH --output=longest_isometric_dkeseries-%j.out
#SBATCH --error=longest_isometric_dkeseries-%j.err

uname -a
echo Started at `date`

module purge
module load python/3.9.0 # needed for longestIsometricCycle.py


SCRIPTDIR=../../scripts

OBS_MAXISOMETRICCYCLE=patricia1993_longest_isometric_cycle.txt

#
# generate tables using longestIsometricCycle.py
# (only run if not exist; so to regenerate remove these files first)
#

if [ ! -f $OBS_MAXISOMETRICCYCLE ]; then 
        echo "# Generated by: $0 $*" > ${OBS_MAXISOMETRICCYCLE}
        echo "# At: " `date` >> ${OBS_MAXISOMETRICCYCLE}
        echo "# On: " `uname -a` >> ${OBS_MAXISOMETRICCYCLE}
        echo "maxlen" >> ${OBS_MAXISOMETRICCYCLE}
	time python3 $SCRIPTDIR/longestIsometricCycle.py patricia1993_edgelist.txt >> ${OBS_MAXISOMETRICCYCLE}
fi


# make table for one dk-series model
# Parameter: dk number (0,1,2,21,25)
run_geodesic_dk() {
    dk=$1
    MAXISOMETRICTAB=dk${dk}_longest_isometric_cycle.txt
    if [ ! -f $MAXISOMETRICTAB ]; then 
        time $SCRIPTDIR/makeLongestISometricCycleLengthTables.sh simulated/dk${dk}/ > ${MAXISOMETRICTAB}
    fi
}

for dk in 0 1 2 21 25
do
  run_geodesic_dk ${dk} &
done
wait

echo Ended at `date` 
