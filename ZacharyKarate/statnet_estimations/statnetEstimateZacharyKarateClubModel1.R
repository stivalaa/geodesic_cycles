#!/usr/bin/env Rscript
###
### File:    statnetEstimateZacharyKarateClubModel1.R
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
### Usage: statnetEstimateZacharyKarateClubModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'zacharykarateclub_statnet_model1.txt'
###   'zacharykarateclub_statnet_model1_mcmcdiagnostics.eps'
###   'zacharykarateclub_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


library(statnet)


options(scipen=9999) # force decimals not scientific notation

data(zach)
gn <- zach

system.time( model1 <- ergm(gn ~ edges + gwdegree(0.2, fixed=TRUE) +  gwesp(0.5, fixed=TRUE)) )

postscript('zacharykarateclub_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

sink('zacharykarateclub_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model1_gof)
postscript('zacharykarateclub_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

