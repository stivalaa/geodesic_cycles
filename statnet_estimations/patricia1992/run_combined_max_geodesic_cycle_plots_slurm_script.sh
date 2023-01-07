#!/bin/bash

#SBATCH --job-name="plot_max_geodesic_cycle"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4GB
#SBATCH --time=0-0:10:00
#SBATCH --output=plot_max_geodesic_cycle-%j.out
#SBATCH --error=plot_max_geodesic_cycle-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts


Rscript $SCRIPTDIR/plotCombinedMaxCycleLengthDistributionsFromTables.R 'geodesic cycle' 'model?_atomiccycledisttable.txt' "dk*_atomiccycledisttable.txt" patricia1992_atomiccycletable.txt patricia1992_combined_max_geodesic.eps

echo Ended at `date` 
