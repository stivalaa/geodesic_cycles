#!/bin/bash

#SBATCH --job-name="plot_max_geodesic_cycle2"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4GB
#SBATCH --time=0-0:10:00
#SBATCH --output=plot_max_geodesic_cycle2-%j.out
#SBATCH --error=plot_max_geodesic_cycle2-%j.err

uname -a
echo Started at `date`

module load r

SCRIPTDIR=../../scripts


Rscript $SCRIPTDIR/plotCombinedMaxCycleLengthDistributionsFromTables.R 'geodesic cycle' ../statnet_estimations/model5_geodesiccycledisttable.txt "dk*_geodesiccycledisttable.txt" greysanatomy_geodesiccycletable.txt greysanatomy_combined2_max_geodesic.eps

echo Ended at `date` 
