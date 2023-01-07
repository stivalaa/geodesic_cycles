#!/bin/bash

#SBATCH --job-name="gensim_model2"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:10:00
#SBATCH --output=gensim_model2-%j.out
#SBATCH --error=gensim_model2-%j.err

uname -a
echo Started at `date`

/usr/bin/time Rscript ../../scripts/generateSimulatedNetworksFromStatnetModel.R  model2.RData simulated/model2

echo Ended at `date` 
