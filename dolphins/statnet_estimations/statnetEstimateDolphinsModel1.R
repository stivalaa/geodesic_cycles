#!/usr/bin/env Rscript
###
### File:    statnetEstimateDolphinsModel1.R
### Author:  Alex Stivala
### Created: August 2019
###
### Estimating ERGM parameters for a model for bottlenose dolphins
### social network.
###
### Citations for data:
###
### Lusseau, D., Schneider, K., Boisseau, O. J., Haase, P., Slooten, E., & Dawson, S. M. (2003). The bottlenose dolphin community of Doubtful Sound features a large proportion of long-lasting associations. Behavioral Ecology and Sociobiology, 54(4), 396-405.
###
### Usage: statnetEstimateDolphinsModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'dolphins_statnet_model1.txt'
###   'dolphins_statnet_model1_mcmcdiagnostics.eps'
###   'dolphins_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###

library(statnet)

options(scipen=9999) # force decimals not scientific notation

gn = read.paj('../data/dolphins.net')
## it is actually undirected, have to do this cumbersome way in statnet
gn <- as.network.matrix(as.matrix.network(gn), directed=FALSE)

system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5,fixed=TRUE) + gwesp(0.1, fixed=TRUE) + gwdsp(0.7, fixed=TRUE), control = control.ergm(main.method="Stepping")) )

postscript('dolphins_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

sink('dolphins_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus + model) )
print(model1_gof)
postscript('dolphins_statnet_model1_gof.eps')
par(mfrow=c(3,3))
plot( model1_gof)
dev.off()

warnings()

