#!/bin/bash

#SBATCH --job-name="cyclelen_model3"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --time=0-2:10:00
#SBATCH --output=cyclelen_distr_model3-%j.out
#SBATCH --error=cyclelen_distr_model3-%j.err

uname -a
echo Started at `date`

/usr/bin/time  Rscript ../../scripts/plotCycleLengthDistributionSimFit.R  model3.RData  patricia1992

echo Ended at `date` 
