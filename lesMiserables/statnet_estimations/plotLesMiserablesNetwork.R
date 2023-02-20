#!/usr/bin/env Rscript
###
### File:    plotLesMiserablesNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Make visualization of Les Miserables character interaction network
###
### Usage: plotLesMiserablesNetwork.R
###
###
### Output is to file
###   'lesmiserables_network.eps'
### WARNING: overwrites output files if they exist
###

library(network)

edgelist <- 'lesmis_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
summary(gn)

postscript('lesmiserables_network.eps')
plot(gn)
dev.off()

