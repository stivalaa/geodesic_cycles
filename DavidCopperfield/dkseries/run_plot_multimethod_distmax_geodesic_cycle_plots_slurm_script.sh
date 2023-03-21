#!/bin/bash

#SBATCH --job-name="plot_multimethods_distmax_geodesic_cycles"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4GB
#SBATCH --time=0-0:10:00
#SBATCH --output=plot_multimethods_distmax_geodesic_cycles-%j.out
#SBATCH --error=plot_multimethods_distmax_geodesic_cycles-%j.err

uname -a
echo Started at `date`

module purge
module load r

SCRIPTDIR=../../scripts

time Rscript ${SCRIPTDIR}/plotCombinedMaxCycleLengthDistributionsFromTablesMultiMethodsDistMax.R 'geodesic cycle' "" "dk*_geodesiccycledisttable.txt" david_geodesiccycletable.txt  "" "dk*_longest_isometric_cycle.txt" david_longest_isometric_cycle.txt "countGeodesicCycles" "longestIsometricCycle" david_combined_max_geodesic_multimodels_distmax.eps


echo Ended at `date` 
