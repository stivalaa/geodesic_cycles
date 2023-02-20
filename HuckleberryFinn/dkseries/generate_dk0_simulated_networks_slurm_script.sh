#!/bin/bash

#SBATCH --job-name="gensim_dk0"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:10:00
#SBATCH --output=gensim_dk0-%j.out
#SBATCH --error=gensim_dk0-%j.err

uname -a
echo Started at `date`

module load r

Rscript ../../scripts/generateSimulatedNetworksFromErdosRenyiModel.R huck_edgelist.txt simulated/dk0

echo Ended at `date` 
