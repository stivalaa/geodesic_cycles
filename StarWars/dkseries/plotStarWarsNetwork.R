#!/usr/bin/env Rscript
###
### File:    plotStarWarsNetwork.R
### Author:  Alex Stivala
### Created: January 2023
###
### Make visualization of STar Wars network
###
### Usage: plotStarWarsNetwork.R
###
###
### Output is to file
###   'starwars_network.eps'
### WARNING: overwrites output files if they exist
###

library(network)

edgelist <- 'starwars_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
summary(gn)

postscript('starwars_network.eps')
plot(gn, edge.col = 'gray')
dev.off()

