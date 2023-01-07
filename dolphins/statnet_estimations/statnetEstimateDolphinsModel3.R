#!/usr/bin/env Rscript
###
### File:    statnetEstimateDolphinsModel3.R
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
### Usage: statnetEstimateDolphinsModel3.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'dolphins_statnet_model3.txt'
###   'dolphins_statnet_model3_mcmcdiagnostics.eps'
###   'dolphins_statnet_model3_gof.eps'
### WARNING: overwrites output files if they exist
###

library(statnet)

options(scipen=9999) # force decimals not scientific notation

gn = read.paj('../data/dolphins.net')
## it is actually undirected, have to do this cumbersome way in statnet
gn <- as.network.matrix(as.matrix.network(gn), directed=FALSE)

system.time( model3 <- ergm(gn ~ edges + gwdegree(0.5,fixed=FALSE) +  gwesp(0.1, fixed=FALSE) + gwdsp(0.7, fixed=FALSE), control = control.ergm(main.method="Stepping")) )

sink('dolphins_statnet_model3.txt')
print( summary(model3) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

# does not work with fixed=FALSE
#postscript('dolphins_statnet_model3_mcmcdiagnostics.eps')
#mcmc.diagnostics(model3)
#dev.off()

save(gn, model3, file = "model3.RData")

system.time( model3_gof <-  gof(model3  ~ degree + distance + espartners + dspartners + triadcensus + model) )
print(model3_gof)
postscript('dolphins_statnet_model3_gof.eps')
par(mfrow=c(3,2))
plot( model3_gof)
dev.off()

warnings()

