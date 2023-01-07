#!/bin/bash

#SBATCH --job-name="statnet_1"
#SBATCH --ntasks=1
#SBATCH --time=0-0:20:00
#SBATCH --mem-per-cpu=16GB
#SBATCH --output=statnet_estimation_model1-%j.out
#SBATCH --error=statnet_estimation_model1-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript statnetEstimateHighSchoolFriendshipModel1.R 

echo Ended at `date` 
