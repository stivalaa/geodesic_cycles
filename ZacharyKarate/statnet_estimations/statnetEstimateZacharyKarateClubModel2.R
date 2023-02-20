#!/usr/bin/env Rscript
###
### File:    statnetEstimateZacharyKarateClubModel2.R
### Author:  Alex Stivala
### Created: August 2019
###
### Estimating ERGM parameters for a model for Zachary karate club
### social network. Reference for data:
###
###  Zachary, W. W. (1977). An information flow model for conflict and
###  fission in small groups. Journal of anthropological research,
###  33(4), 452-473.
###
### Usage: statnetEstimateZacharyKarateClubModel2.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'zacharykarateclub_statnet_model2.txt'
###   'zacharykarateclub_statnet_model2_mcmcdiagnostics.eps'
###   'zacharykarateclub_statnet_model2_gof.eps'
### WARNING: overwrites output files if they exist
###


library(statnet)


options(scipen=9999) # force decimals not scientific notation

data(zach)
gn <- zach

system.time( model2 <- ergm(gn ~ edges + gwdegree(0.2, fixed=TRUE) +  gwesp(0.5, fixed=TRUE) + nodefactor("role",base=2)+absdiffcat("faction.id")) )

postscript('zacharykarateclub_statnet_model2_mcmcdiagnostics.eps')
mcmc.diagnostics(model2)
dev.off()

sink('zacharykarateclub_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model2, file = "model2.RData")

system.time( model2_gof <-  gof(model2  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model2_gof)
postscript('zacharykarateclub_statnet_model2_gof.eps')
par(mfrow=c(3,2))
plot( model2_gof)
dev.off()

warnings()

