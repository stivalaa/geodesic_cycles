#!/usr/bin/env Rscript
###
### File:    plotDumbledoresArmyNetwork.R
### Author:  Alex Stivala
### Created: January 2023
###
### Make visualization of Dumbledore's Army network
###
### Usage: plotDumbledoresArmyNetwork.R
###
###
### Output is to file
###   'dumbledoresarmy_network.eps'
### WARNING: overwrites output files if they exist
###

library(network)

edgelist <- 'dumbledoresarmy_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
summary(gn)

postscript('dumbledoresarmy_network.eps')
plot(gn)
dev.off()

