#!/bin/bash

#SBATCH --job-name="longest_isometric_model3"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-1:00:00
#SBATCH --output=longest_isometric_model3-%j.out
#SBATCH --error=longest_isometric_model3-%j.err

uname -a
echo Started at `date`

module purge
module load python/3.9.0 # needed for longestIsometricCycle.py


SCRIPTDIR=../../scripts

MAXISOMETRICTAB=model3_longest_isometric_cycle.txt


OBS_MAXISOMETRICCYCLE=patricia1992_longest_isometric_cycle.txt

#
# generate tables using longestIsometricCycle.py
# (only run if not exist; so to regenerate remove these files first)
#

if [ ! -f $OBS_MAXISOMETRICCYCLE ]; then 
        echo "# Generated by: $0 $*" > ${OBS_MAXISOMETRICCYCLE}
        echo "# At: " `date` >> ${OBS_MAXISOMETRICCYCLE}
        echo "# On: " `uname -a` >> ${OBS_MAXISOMETRICCYCLE}
        echo "maxlen" >> ${OBS_MAXISOMETRICCYCLE}
	time python3 $SCRIPTDIR/longestIsometricCycle.py patricia1992_edgelist.txt >> ${OBS_MAXISOMETRICCYCLE}
fi

if [ ! -f $MAXISOMETRICTAB ]; then 
	time $SCRIPTDIR/makeLongestISometricCycleLengthTables.sh simulated/model3/ > ${MAXISOMETRICTAB}
fi


echo Ended at `date` 
