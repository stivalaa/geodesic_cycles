#!/usr/bin/env Rscript
###
### File:    plotDavidCopperfieldNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Make visualization of Anna KArenina character interaction network
###
### Usage: plotDavidCopperfieldNetwork.R
###
###
### Output is to file
###   'davidcopperfield_network.eps'
### WARNING: overwrites output files if they exist
###

library(network)

edgelist <- 'david_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
summary(gn)

postscript('davidcopperfield_network.eps')
plot(gn)
dev.off()

