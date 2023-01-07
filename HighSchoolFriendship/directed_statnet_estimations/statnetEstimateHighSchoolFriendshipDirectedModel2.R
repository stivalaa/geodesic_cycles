#!/usr/bin/env Rscript
###
### File:    statnetEstimateHighSchoolFriendshipDirectedModel2.R
### Author:  Alex Stivala
### Created: September 2019
###
### Estimating ERGM parameters for a model for SocioPatterns
### high schol friendship social network (treated as directed).
###
### Usage: statnetEstimateHighSchoolFriendshipDirectedModel2.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'highschoolfriendship_directed_statnet_model2.txt'
###   'highschoolfriendship_directed_statnet_model2_mcmcdiagnostics.eps'
###   'highschoolfriendship_directed_statnet_model2_gof.eps'
### WARNING: overwrites output files if they exist
###


source('load_highschoolfriendship_directed_network.R')

options(scipen=9999) # force decimals not scientific notation

g <- load_highschoolfriendship_directed_network()

# do this after igraph etc. so namespace not messed up
library(statnet)
library(intergraph)

gn <- asNetwork(g)
summary(gn)

system.time(model2 <- ergm(gn ~ edges + mutual + gwidegree(.2, fixed=TRUE) + gwodegree(.2, fixed=TRUE) + gwesp(.7, fixed=TRUE) + gwdsp(1.4, fixed=TRUE) + nodematch('class') + mutual(same='class'), control = control.ergm(main.method="MCMLE", MCMC.burnin=100000, MCMC.interval=8192)) )


postscript('highschoolfriendship_directed_statnet_model2_mcmcdiagnostics.eps')
mcmc.diagnostics(model2)
dev.off()

sink('highschoolfriendship_directed_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model2, file = "model2.RData")

system.time( model2_gof <- gof(model2  ~ idegree + odegree + distance + espartners + dspartners + triadcensus)  )
print(model2_gof)
postscript('highschoolfriendship_directed_statnet_model2_gof.eps')
par(mfrow=c(3,2))
plot( model2_gof)
dev.off()

warnings()

