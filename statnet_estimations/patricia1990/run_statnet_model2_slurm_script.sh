#!/bin/bash

#SBATCH --job-name="statnet_model2"
#SBATCH --ntasks=1
#SBATCH --time=0-0:20:00
#SBATCH --mem-per-cpu=8GB
#SBATCH --output=statnet_estimation_model2-%j.out
#SBATCH --error=statnet_estimation_model2-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript statnetEstimatePatricia1990Model2.R 

echo Ended at `date` 
