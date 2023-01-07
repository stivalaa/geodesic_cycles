#!/bin/bash

#SBATCH --job-name="R_plot_geodesic_model2"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-00:10:00
#SBATCH --output=R_plot_geodesic_model2-%j.out
#SBATCH --error=R_plot_geodesic_model2-%j.err


# use submit_makeGeodesicCycleLengthDistributionTables_model2_jobs.sh
# script, which submits makeGeodesicCycleLengthDistributionTables_model2_jobarray_slurm_script.sh
# to generate tables in parallel, then this script to combine and plot them with
# R

uname -a
echo Started at `date`

module purge # otherwise sometimes module load r fails
module load r

SCRIPTDIR=../../scripts

GEODESICTAB=model2_geodesiccycledisttable.txt
OBS_GEODESICCYCLETAB=highschoolfriendship_geodesiccycletable.txt

echo "sim length count" > ${GEODESICTAB}
cat model2_geodesiccycletable_*.txt | fgrep -v 'sim length count' >> ${GEODESICTAB}

#
# generate plots from tables with R
#

time Rscript $SCRIPTDIR/plotCycleLengthDistributionsFromTables.R 'ERGM' 'geodesic cycle'  ${GEODESICTAB} ${OBS_GEODESICCYCLETAB}


echo Ended at `date` 
