#!/bin/bash

#SBATCH --job-name="gensim_dkseries"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-6:00:00
#SBATCH --output=gensim_dkseries-%j.out
#SBATCH --error=gensim_dkseries-%j.err
## problem with icsnode32 (CPU wait) so using fat not slim 10/01/2023
#SBATCH -p fat

uname -a
echo Started at `date`

for dk in 1 2 2.1 2.5
do
    dk_no_period=`echo "${dk}" | sed 's/[.]//g'`
    ../../scripts/generateSimulatedNetworksFromDKseries.sh $dk lesmis_edgelist.txt simulated/dk${dk_no_period}
done

echo Ended at `date` 
