#!/usr/bin/env Rscript
###
### File:    statnetEstimateHighSchoolFriendshipModel1.R
### Author:  Alex Stivala
### Created: September 2019
###
### Estimating ERGM parameters for a model for SocioPatterns
### high schol friendship social network (treated as undirected).
###
### Usage: statnetEstimateHighSchoolFriendshipModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'highschoolfriendship_statnet_model1.txt'
###   'highschoolfriendship_statnet_model1_mcmcdiagnostics.eps'
###   'highschoolfriendship_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


source('load_highschoolfriendship_network.R')

options(scipen=9999) # force decimals not scientific notation

g <- load_highschoolfriendship_network()

# do this after igraph etc. so namespace not messed up
library(statnet)
library(intergraph)

gn <- asNetwork(g)
print(gn)

system.time(model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=FALSE) + gwesp(.5, fixed=FALSE) + gwdsp(.5, fixed=TRUE) +  nodematch('class'), control = control.ergm(main.method="MCMLE", MCMC.burnin=10000, MCMC.interval=4096)) )
##system.time(model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=TRUE) + gwesp(.5, fixed=TRUE) + gwdsp(.5, fixed=TRUE) + nodematch('sex') + nodematch('class'), control = control.ergm(main.method="MCMLE", MCMC.burnin=10000, MCMC.interval=4096)) )


postscript('highschoolfriendship_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

sink('highschoolfriendship_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model1_gof)
postscript('highschoolfriendship_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

