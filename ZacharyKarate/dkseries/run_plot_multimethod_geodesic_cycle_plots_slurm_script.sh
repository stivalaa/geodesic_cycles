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


Rscript ${SCRIPTDIR}/plotCycleLengthDistributionsFromTablesMultiMethods.R "dk-series 2.5k" 'geodesic cycle' dk25_atomiccycledisttable.txt zacharykarateclub_atomiccycletable.txt dk25_geodesiccycledisttable.txt zachary_karateclub_geodesiccycletable.txt "findAtomicCycles" "countGeodesicCycles"

Rscript ${SCRIPTDIR}/plotCycleLengthDistributionsFromTablesMultiMethods.R "ERGM" 'geodesic cycle' ../statnet_estimations/model2_atomiccycledisttable.txt zacharykarateclub_atomiccycletable.txt ../statnet_estimations/model2_geodesiccycledisttable.txt zachary_karateclub_geodesiccycletable.txt "findAtomicCycles" "countGeodesicCycles"

Rscript ${SCRIPTDIR}/plotCombinedMaxCycleLengthDistributionsFromTablesMultiMethods.R 'geodesic cycle' ../statnet_estimations/model2_atomiccycledisttable.txt "dk*_atomiccycledisttable.txt" zacharykarateclub_atomiccycletable.txt ../statnet_estimations/model2_geodesiccycledisttable.txt "dk*_geodesiccycledisttable.txt" zachary_karateclub_geodesiccycletable.txt "findAtomicCycles" "countGeodesicCycles" zacharykarateclub_combined_max_geodesic_multimodels.eps 

times
echo Ended at `date` 
