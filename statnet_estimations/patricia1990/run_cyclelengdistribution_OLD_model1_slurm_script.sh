#!/bin/bash

#SBATCH --job-name="cyclelen_model1"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --time=0-0:10:00
#SBATCH --output=cyclelen_distr_model1-%j.out
#SBATCH --error=cyclelen_distr_model1-%j.err

uname -a
echo Started at `date`

/usr/bin/time  Rscript ../../scripts/plotCycleLengthDistributionSimFit.R  model1.RData  patricia1990

echo Ended at `date` 
