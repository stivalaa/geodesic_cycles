#!/usr/bin/env Rscript
###
### File:    statnetEstimateHighSchoolFriendshipModel2.R
### Author:  Alex Stivala
### Created: September 2019
###
### Estimating ERGM parameters for a model for SocioPatterns
### high schol friendship social network (treated as undirected).
###
### Usage: statnetEstimateHighSchoolFriendshipModel2.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'highschoolfriendship_statnet_model2.txt'
###   'highschoolfriendship_statnet_model2_mcmcdiagnostics.eps'
###   'highschoolfriendship_statnet_model2_gof.eps'
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

system.time(model2 <- ergm(gn ~ edges + gwdegree(1.7, fixed=TRUE) + gwesp(1.2, fixed=TRUE) + gwdsp(.5, fixed=TRUE) +  nodematch('class'), control = control.ergm(main.method="MCMLE", MCMC.burnin=10000, MCMC.interval=8192)) )
##system.time(model2 <- ergm(gn ~ edges + gwdegree(.5, fixed=FALSE) + gwesp(.5, fixed=FALSE) + gwdsp(.5, fixed=TRUE) +  nodematch('class') + nodematch('sex'), control = control.ergm(main.method="MCMLE", MCMC.burnin=10000, MCMC.interval=4096)) )


postscript('highschoolfriendship_statnet_model2_mcmcdiagnostics.eps')
mcmc.diagnostics(model2)
dev.off()

sink('highschoolfriendship_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model2, file = "model2.RData")

system.time( model2_gof <-  gof(model2  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model2_gof)
postscript('highschoolfriendship_statnet_model2_gof.eps')
par(mfrow=c(3,2))
plot( model2_gof)
dev.off()

warnings()

