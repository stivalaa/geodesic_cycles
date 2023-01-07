#!/bin/bash

#SBATCH --job-name="gof"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4GB
#SBATCH --time=0-0:10:00
#SBATCH --output=gof_simfit-%j.out
#SBATCH --error=gof_simfit-%j.err

uname -a
echo Started at `date`

SCRIPTDIR=../../scripts


OBS_EDGELIST=greysanatomy_edgelist.txt

time Rscript $SCRIPTDIR/plotUndirectedSimFit.R $OBS_EDGELIST "../statnet_estimations/simulated/model5/sim_model5_*_edgelist.txt" statnet_model5_simfit_gof.pdf

for dk in 0 1 2 21 25
do
  time Rscript $SCRIPTDIR/plotUndirectedSimFit.R $OBS_EDGELIST "simulated/dk${dk}/sim_modeldk${dk}_*_edgelist.txt" dk${dk}_simfit_gof.pdf
done

echo Ended at `date` 
