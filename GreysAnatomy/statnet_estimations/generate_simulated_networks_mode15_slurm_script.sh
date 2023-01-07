#!/bin/bash

#SBATCH --job-name="gensim_model5"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:10:00
#SBATCH --output=gensim_model5-%j.out
#SBATCH --error=gensim_model5-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript ../../scripts/generateSimulatedNetworksFromStatnetModel.R  model5.RData simulated/model5

echo Ended at `date` 
