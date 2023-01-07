#!/usr/bin/env Rscript
###
### File:    plotDolphinsNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Draw visualization for bottlenose dolphins social network.
###
### Citations for data:
###
### Lusseau, D., Schneider, K., Boisseau, O. J., Haase, P., Slooten, E., & Dawson, S. M. (2003). The bottlenose dolphin community of Doubtful Sound features a large proportion of long-lasting associations. Behavioral Ecology and Sociobiology, 54(4), 396-405.
###
### Usage: plotDolphinsNetwork.R
###
###
### writes output files to cwd:
###   'dolphins_network.eps'
### WARNING: overwrites output files if they exist
###

library(statnet)


gn = read.paj('../data/dolphins.net')
## it is actually undirected, have to do this cumbersome way in statnet
gn <- as.network.matrix(as.matrix.network(gn), directed=FALSE)

summary(gn)
postscript('dolphins_network.eps')
plot(gn, displaylabels=TRUE, label.cex=.75)
dev.off()

