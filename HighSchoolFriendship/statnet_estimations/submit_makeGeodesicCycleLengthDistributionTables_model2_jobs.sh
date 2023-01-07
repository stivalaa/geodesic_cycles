#!/bin/bash

# Submit job array to do each simulated network in parallel, and another
# job to process output with R script, waiting for parallel jobs to finish
# first

jobid=$(sbatch --parsable  makeGeodesicCycleLengthDistributionTables_model2_jobarray_slurm_script.sh)
echo ${jobid}
sbatch --dependency=afterok:${jobid} run_plot_R_script_model_slurm_script.sh
