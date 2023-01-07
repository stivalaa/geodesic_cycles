#!/bin/bash

#SBATCH --job-name="statnet_4"
#SBATCH --ntasks=1
#SBATCH --time=0-5:20:00
#SBATCH --mem-per-cpu=16GB
#SBATCH --output=statnet_estimation_model4-%j.out
#SBATCH --error=statnet_estimation_model4-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript statnetEstimateHighSchoolFriendshipModel4.R 

echo Ended at `date` 
