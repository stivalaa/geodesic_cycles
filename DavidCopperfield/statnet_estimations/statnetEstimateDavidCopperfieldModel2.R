#!/usr/bin/env Rscript
###
### File:    statnetEstimateDavidCopperfieldModel2.R
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
### Usage: statnetEstimateDavidCopperfieldModel2.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'davidcopperfield_statnet_model2.txt'
###   'davidcopperfield_statnet_model2_mcmcdiagnostics.eps'
###   'davidcopperfield_statnet_model2_gof.eps'
### WARNING: overwrites output files if they exist
###


library(statnet)


options(scipen=9999) # force decimals not scientific notation

edgelist <- 'david_edgelist.txt'
el <- read.table(edgelist, header=FALSE)
gn <- network(as.matrix(el)+1, directed=FALSE) # input is 0 based
summary(gn)

# system is computationally signgular:
#system.time( model2 <- ergm(gn ~ edges + gwdegree(.9, fixed=TRUE) +   gwesp(0.9, fixed=TRUE), control = control.ergm(main.method = "MCMLE", MCMC.interval = 4096)) )

# did not mix at all:
#system.time( model2 <- ergm(gn ~ edges + gwdegree(1.5, fixed=TRUE) +   gwesp(0.9, fixed=TRUE), control = control.ergm(main.method = "MCMLE", MCMC.interval = 4096)) )

sink('davidcopperfield_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()


postscript('davidcopperfield_statnet_model2_mcmcdiagnostics.eps')
mcmc.diagnostics(model2)
dev.off()

sink('davidcopperfield_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model2, file = "model2.RData")

system.time( model2_gof <-  gof(model2  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model2_gof)
postscript('davidcopperfield_statnet_model2_gof.eps')
par(mfrow=c(3,2))
plot( model2_gof)
dev.off()

warnings()

