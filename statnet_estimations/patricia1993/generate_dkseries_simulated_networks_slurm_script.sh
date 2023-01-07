#!/bin/bash

#SBATCH --job-name="gensim_dkseries"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:10:00
#SBATCH --output=gensim_dkseries-%j.out
#SBATCH --error=gensim_dkseries-%j.err

uname -a
echo Started at `date`

for dk in 0 1 2 2.1 2.5
do
    dk_no_period=`echo "${dk}" | sed 's/[.]//g'`
    ../../scripts/generateSimulatedNetworksFromDKseries.sh $dk patricia1993_edgelist.txt simulated/dk${dk_no_period}
done

echo Ended at `date` 
