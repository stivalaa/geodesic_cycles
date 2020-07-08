#!/usr/bin/Rscript
##
## File:    generateSimulatedNetworksFromStatnetModel
## Author:  Alex Stivala
## Created: July 2019
##
## Read statnet model and associated network (written by e.g.
## patricia1992/statnetEstimatePatricia1992Model1.R), simulate networks
## from the model, and save as edge lists.
##
## Usage: Rscript generateSimulatedNetworksFromStatnetModel model.RData outdirname
##
##    model.RData is R save file with network and model
##    outdirname is output directory (Created if not exists).
##    Ouput files are written in that directory as:
##        sim_modelname_X_edgelist.txt
##    where modelname is name of model object from RData and X is sequence 
##    number e.g. sim_model1_32_edgelist.txt
##
##  WARNING: output files are overwritten
##
## Example:
##      Rscript generateSimulatedNetworksFromStatnetModel model1.RData simulated/model1
##
##

library(statnet)

###
### Main
###

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 2) {
  cat("Usage: Rscript generateSimulatedNetworksFromStatnetModel model.RData outdirname\n")
  quit(save="no")
}
modelfilename <- args[1]
outdirname <- args[2]

## note we assume the model is the filename e.g. model1.RData contains
## model1 as the statnet model object and the network as gn
modelname <- sub("(.+)[.].+", "\\1", basename(modelfilename))
load(modelfilename)
model <- eval(parse(text = modelname))

summary(gn)
summary(model)


##
## generate simulated networks from model
##
num_sim <- 100
cat("simulating ", num_sim, " newtorks from model...")
system.time( gsim_list <- simulate(model, nsim=num_sim) )

##
## write edgelists
##
dir.create(outdirname, recursive = TRUE)
cat('writing to directory ', outdirname, '\n')
for (i in 1:length(gsim_list)) {
  outfilename <- paste('sim_', modelname, '_', i, '_edgelist.txt', sep='')
  el <- as.edgelist(gsim_list[[i]]) - 1 # convertt to 0-based not 1-based for CYPATH
  write.table(el, file.path(outdirname, outfilename), col.names=F, row.names=F)
}

