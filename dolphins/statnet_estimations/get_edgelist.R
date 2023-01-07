#!/usr/bin/env Rscript
###
### File:    get_edgelist.R
### Author:  Alex Stivala
### Created: August 2019
###
### Get dolphins network in edgelist format  (zero-based node ids)
###
### Citations for data:
###
### Lusseau, D., Schneider, K., Boisseau, O. J., Haase, P., Slooten, E., & Dawson, S. M. (2003). The bottlenose dolphin community of Doubtful Sound features a large proportion of long-lasting associations. Behavioral Ecology and Sociobiology, 54(4), 396-405.
###
### Usage: get_edgelist.R
###
###
### writes output files to cwd:
###   'dolphins_edgelist.txt'
### WARNING: overwrites output files if they exist
###

library(statnet)


gn = read.paj('../data/dolphins.net')
## it is actually undirected, have to do this cumbersome way in statnet
gn <- as.network.matrix(as.matrix.network(gn), directed=FALSE)

summary(gn)
write.table(as.edgelist(gn)-1, file='dolphins_edgelist.txt', col.names=FALSE, row.names=FALSE)
