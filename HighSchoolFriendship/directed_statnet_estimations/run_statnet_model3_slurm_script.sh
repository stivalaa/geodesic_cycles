#!/bin/bash

#SBATCH --job-name="statnet_3"
#SBATCH --ntasks=1
#SBATCH --time=0-5:20:00
#SBATCH --mem-per-cpu=16GB
#SBATCH --output=statnet_estimation_model3-%j.out
#SBATCH --error=statnet_estimation_model3-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript statnetEstimateHighSchoolFriendshipDirectedModel3.R

echo Ended at `date` 
