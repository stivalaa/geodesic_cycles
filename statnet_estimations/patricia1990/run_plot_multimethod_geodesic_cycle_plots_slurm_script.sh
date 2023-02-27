#!/bin/bash

#SBATCH --job-name="plot_multimethods_geodesic_cycles"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4GB
#SBATCH --time=0-0:10:00
#SBATCH --output=plot_multimethods_geodesic_cycles-%j.out
#SBATCH --error=plot_multimethods_geodesic_cycles-%j.err

uname -a
echo Started at `date`

module load r

SCRIPTDIR=../../scripts


Rscript ${SCRIPTDIR}/plotCycleLengthDistributionsFromTablesMultiMethods.R "dk-series 2.5k" 'geodesic cycle' dk25_atomiccycledisttable.txt patricia1990_atomiccycletable.txt dk25_geodesiccycledisttable.txt patricia1990_geodesiccycletable.txt "findAtomicCycles" "countGeodesicCycles"

Rscript ${SCRIPTDIR}/plotCycleLengthDistributionsFromTablesMultiMethods.R "ERGM" 'geodesic cycle' model1_atomiccycledisttable.txt patricia1990_atomiccycletable.txt model1_geodesiccycledisttable.txt patricia1990_geodesiccycletable.txt "findAtomicCycles" "countGeodesicCycles"

Rscript ${SCRIPTDIR}/plotCombinedMaxCycleLengthDistributionsFromTablesMultiMethods.R 'geodesic cycle' model1_atomiccycledisttable.txt "dk*_atomiccycledisttable.txt" patricia1990_atomiccycletable.txt model1_geodesiccycledisttable.txt "dk*_geodesiccycledisttable.txt" patricia1990_geodesiccycletable.txt "findAtomicCycles" "countGeodesicCycles" patricia1990_combined_max_geodesic_multimodels.eps 

times
echo Ended at `date` 
