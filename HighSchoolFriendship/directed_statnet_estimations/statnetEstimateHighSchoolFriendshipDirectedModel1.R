#!/usr/bin/env Rscript
###
### File:    statnetEstimateHighSchoolFriendshipDirectedModel1.R
### Author:  Alex Stivala
### Created: September 2019
###
### Estimating ERGM parameters for a model for SocioPatterns
### high schol friendship social network (treated as directed).
###
### Usage: statnetEstimateHighSchoolFriendshipDirectedModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'highschoolfriendship_directed_statnet_model1.txt'
###   'highschoolfriendship_directed_statnet_model1_mcmcdiagnostics.eps'
###   'highschoolfriendship_directed_statnet_model1_gof.eps'
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

system.time(model1 <- ergm(gn ~ edges + mutual + gwidegree(.5) + gwodegree(.5) + gwesp + gwdsp + nodematch('class') + mutual(same='class'), control = control.ergm(main.method="MCMLE", MCMC.burnin=500000, MCMC.interval=8192)) )


postscript('highschoolfriendship_directed_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

sink('highschoolfriendship_directed_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <- gof(model1  ~ idegree + odegree + distance + espartners + dspartners + triadcensus)  )
print(model1_gof)
postscript('highschoolfriendship_directed_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

