#!/usr/bin/env Rscript
###
### File:    plotHuckleberryFinnNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Make visualization of Huckleberry Finn character interaction network
###
### Usage: plotHuckleberryFinnNetwork.R
###
###
### Output is to file
###   'huckleberryfinn_network.eps'
### WARNING: overwrites output files if they exist
###

library(network)

edgelist <- 'huck_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
print(gn)

postscript('huckleberryfinn_network.eps')
plot(gn)
dev.off()

