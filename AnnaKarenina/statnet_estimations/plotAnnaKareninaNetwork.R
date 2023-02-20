#!/usr/bin/env Rscript
###
### File:    plotAnnaKareninaNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Make visualization of Anna KArenina character interaction network
###
### Usage: plotAnnaKareninaNetwork.R
###
###
### Output is to file
###   'annakarenina_network.eps'
### WARNING: overwrites output files if they exist
###

library(network)

edgelist <- 'anna_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
summary(gn)

postscript('annakarenina_network.eps')
plot(gn)
dev.off()

