#!/bin/bash

#SBATCH --job-name="gensim_model4"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:10:00
#SBATCH --output=gensim_model4-%j.out
#SBATCH --error=gensim_model4-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript ../../scripts/generateSimulatedNetworksFromStatnetModel.R  model4.RData simulated/model4

echo Ended at `date` 
