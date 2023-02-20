#!/bin/bash

#SBATCH --job-name="statnet_1"
#SBATCH --ntasks=1
#SBATCH --time=0-8:20:00
#SBATCH --mem-per-cpu=32GB
#SBATCH --output=statnet_estimation_model1-%j.out
#SBATCH --error=statnet_estimation_model1-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript statnetEstimateAnnaKareninaModel1.R 

echo Ended at `date` 
