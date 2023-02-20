#!/bin/bash

#SBATCH --job-name="gensim_dk0"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-2:00:00
#SBATCH --output=gensim_dk0-%j.out
#SBATCH --error=gensim_dk0-%j.err
## problem with icsnode32 (CPU wait) so using fat not slim 10/01/2023
#SBATCH -p fat

uname -a
echo Started at `date`

module load r

Rscript ../../scripts/generateSimulatedNetworksFromErdosRenyiModel.R lesmis_edgelist.txt simulated/dk0

echo Ended at `date` 
