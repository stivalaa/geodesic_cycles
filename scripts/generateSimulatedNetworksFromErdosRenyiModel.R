#!/usr/bin/Rscript
##
## File:    generateSimulatedNetworksFromErdosRenyiModel
## Author:  Alex Stivala
## Created: June 2020
##
##
## Read network in edge list format (undirected unweighted) and generate
## G(n, m) random graphs where n is number of nodes in input (observed)
## network and m is number of edges.
##
## Usage: Rscript generateSimulatedNetworksFromErdosRenyiModel edgelist.txt outdirname
##
##
##    outdirname is output directory (Created if not exists).
##    Ouput files are written in that directory as:
##        sim_modeldk0_X_edgelist.txt
##
##  (Note the dk0 naming convention to fit in with the dk-series models -
##  the RandNetGen program only generates dk1, dk2, dk2,1, dk2.5, and not
##  dk0, which is just Erdos-Renyi random graphs).
##
##  WARNING: output files are overwritten
##
## Example:
##      Rscript generateSimulatedNetworksFromErdosRenyiModel.R patricia1990_edgelist.txt simulated/dk0
##
##

library(igraph)

###
### Main
###

modelname <- 'modeldk0'
num_sim <- 100

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 2) {
  cat("Usage: Rscript generateSimulatedNetworksFromErdosRenyiModel.R edgelist.txt outdirname\n")
  quit(save="no")
}
netfilename <- args[1]
outdirname  <- args[2]

##
## Read observed graph and get n and m
##
g_obs <- as.undirected(read.graph(netfilename, format='edgelist'))
num_nodes <- vcount(g_obs)
num_edges <- ecount(g_obs)

##
## generate simulated Erdos-Renyi networks and
## write edgelists
##
dir.create(outdirname, recursive = TRUE)
cat('writing to directory ', outdirname, '\n')
for (i in 1:num_sim) {
  gsim <- sample_gnm(n = num_nodes, m = num_edges)
  ##gsim <- sample_gnp(n = num_nodes, p = graph.density(g_obs))
  outfilename <- paste('sim_', modelname, '_', i, '_edgelist.txt', sep='')
  write.graph(gsim, file.path(outdirname, outfilename), format='edgelist')
}

