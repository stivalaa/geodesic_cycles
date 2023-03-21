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

time Rscript ${SCRIPTDIR}/plotCombinedMaxCycleLengthDistributionsFromTablesMultiMethodsDistMax.R 'geodesic cycle' ../statnet_estimations/model2_geodesiccycledisttable.txt "dk*_geodesiccycledisttable.txt" kapferer_tailorshop_geodesiccycletable.txt  ../statnet_estimations/model2_longest_isometric_cycle.txt "dk*_longest_isometric_cycle.txt" kapferertailorshop_longest_isometric_cycle.txt "countGeodesicCycles" "longestIsometricCycle" kapferer_tailorshop_combined_max_geodesic_multimodels_distmax.eps


echo Ended at `date` 
