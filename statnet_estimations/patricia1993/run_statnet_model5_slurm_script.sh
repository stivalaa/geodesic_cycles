#!/bin/bash

#SBATCH --job-name="statnet_model5"
#SBATCH --ntasks=1
#SBATCH --time=0-0:20:00
#SBATCH --mem-per-cpu=8GB
#SBATCH --output=statnet_estimation_model5-%j.out
#SBATCH --error=statnet_estimation_model5-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript statnetEstimatePatricia1993Model5.R 

echo Ended at `date` 
