#!/bin/bash

#SBATCH --job-name="statnet_4"
#SBATCH --ntasks=1
#SBATCH --time=0-18:00:00
#SBATCH --mem-per-cpu=8GB
#SBATCH --output=statnet_estimation_model4-%j.out
#SBATCH --error=statnet_estimation_model4-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript statnetEstimateGreysAnatomyModel4.R 

echo Ended at `date` 
