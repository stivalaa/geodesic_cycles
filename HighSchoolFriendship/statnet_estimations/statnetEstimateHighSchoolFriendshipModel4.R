#!/usr/bin/env Rscript
###
### File:    statnetEstimateHighSchoolFriendshipModel4.R
### Author:  Alex Stivala
### Created: September 2019
###
### Estimating ERGM parameters for a model for SocioPatterns
### high schol friendship social network (treated as undirected).
###
### Usage: statnetEstimateHighSchoolFriendshipModel4.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'highschoolfriendship_statnet_model4.txt'
###   'highschoolfriendship_statnet_model4_mcmcdiagnostics.eps'
###   'highschoolfriendship_statnet_model4_gof.eps'
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

system.time(model4 <- ergm(gn ~ edges + gwdegree(1.7, fixed=TRUE) + gwesp(1.2, fixed=TRUE) + gwdsp(.5, fixed=TRUE) +  nodematch('class') + nodefactor('class'), control = control.ergm(main.method="MCMLE", MCMC.burnin=10000, MCMC.interval=8192)) )


postscript('highschoolfriendship_statnet_model4_mcmcdiagnostics.eps')
mcmc.diagnostics(model4)
dev.off()

sink('highschoolfriendship_statnet_model4.txt')
print( summary(model4) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model4, file = "model4.RData")

system.time( model4_gof <-  gof(model4  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model4_gof)
postscript('highschoolfriendship_statnet_model4_gof.eps')
par(mfrow=c(3,2))
plot( model4_gof)
dev.off()

warnings()

