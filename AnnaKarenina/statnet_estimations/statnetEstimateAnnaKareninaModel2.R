#!/usr/bin/env Rscript
###
### File:    statnetEstimateAnnaKareninaModel2.R
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
### Usage: statnetEstimateAnnaKareninaModel2.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'annakarenina_statnet_model2.txt'
###   'annakarenina_statnet_model2_mcmcdiagnostics.eps'
###   'annakarenina_statnet_model2_gof.eps'
### WARNING: overwrites output files if they exist
###


library(statnet)


options(scipen=9999) # force decimals not scientific notation

edgelist <- 'anna_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
summary(gn)

#system is computationally singular:
#system.time( model2 <- ergm(gn ~ edges + gwdegree(0.2, fixed=TRUE) + gwdsp(0.2, fixed=TRUE) +  gwesp(0.5, fixed=FALSE), control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

sink('annakarenina_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

postscript('annakarenina_statnet_model2_mcmcdiagnostics.eps')
mcmc.diagnostics(model2)
dev.off()

save(gn, model2, file = "model2.RData")

system.time( model2_gof <-  gof(model2  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model2_gof)
postscript('annakarenina_statnet_model2_gof.eps')
par(mfrow=c(3,2))
plot( model2_gof)
dev.off()

warnings()

