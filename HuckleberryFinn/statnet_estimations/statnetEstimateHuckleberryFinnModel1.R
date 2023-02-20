#!/usr/bin/env Rscript
###
### File:    statnetEstimateHuckleberryFinnModel1.R
### Author:  Alex Stivala
### Created: August 2019
###
### Estimating ERGM parameters for a model for Anna Karenina charcter
### interacgtion network. Reference for data:
###
###   Donald Knuth,
###   The Stanford Graph Base: A Platform for Combinatorial Computing,
###   ACM Press, 1993,  ISBN: 0201542757
###
### Usage: statnetEstimateHuckleberryFinnModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'huckleberryfinn_statnet_model1.txt'
###   'huckleberryfinn_statnet_model1_mcmcdiagnostics.eps'
###   'huckleberryfinn_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


library(statnet)


options(scipen=9999) # force decimals not scientific notation

edgelist <- 'huck_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
print(gn)

system.time( model1 <- ergm(gn ~ edges + gwdegree(0.01, fixed=TRUE) +gwesp(2.5, fixed=TRUE)  , control = control.ergm(main.method="Stepping", MCMC.interval=10000)) )

sink('huckleberryfinn_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

postscript('huckleberryfinn_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model1_gof)
postscript('huckleberryfinn_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

