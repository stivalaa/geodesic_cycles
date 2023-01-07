#!/bin/bash

#SBATCH --job-name="cyclelen_model2"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --time=0-8:10:00
#SBATCH --output=cyclelen_distr_model2-%j.out
#SBATCH --error=cyclelen_distr_model2-%j.err

uname -a
echo Started at `date`

/usr/bin/time  Rscript ../../scripts/plotCycleLengthDistributionSimFit.R  model2.RData  patricia1992

echo Ended at `date` 
