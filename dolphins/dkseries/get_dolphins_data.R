###
### File:    get_dolphins_data.R
### Author:  Alex Stivala
### Created: May 2020
###
### Load the dophins network and convert to plain edgelist
### (no attributes) for RandNetGen
###

library(statnet)

gn = read.paj('../data/dolphins.net')
## it is actually undirected, have to do this cumbersome way in statnet
gn <- as.network.matrix(as.matrix.network(gn), directed=FALSE)
el <- as.edgelist(gn)-1 # convertt to 0-based not 1-based
write.table(el, 'dolphins_edgelist.txt', col.names=F, row.names=F)

