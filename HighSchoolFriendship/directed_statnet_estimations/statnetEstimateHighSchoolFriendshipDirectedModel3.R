#!/usr/bin/env Rscript
###
### File:    statnetEstimateHighSchoolFriendshipDirectedModel3.R
### Author:  Alex Stivala
### Created: September 2019
###
### Estimating ERGM parameters for a model for SocioPatterns
### high schol friendship social network (treated as directed).
###
### Usage: statnetEstimateHighSchoolFriendshipDirectedModel3.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'highschoolfriendship_directed_statnet_model3.txt'
###   'highschoolfriendship_directed_statnet_model3_mcmcdiagnostics.eps'
###   'highschoolfriendship_directed_statnet_model3_gof.eps'
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

system.time(model3 <- ergm(gn ~ edges + mutual + gwidegree(.2, fixed=TRUE) + gwodegree(.2, fixed=TRUE) + gwesp(.7, fixed=TRUE) + gwdsp(1.4, fixed=TRUE) + nodematch('class') + mutual(same='class') + nodematch('sex') + mutual('sex'), control = control.ergm(main.method="MCMLE", MCMC.burnin=100000, MCMC.interval=8192)) )


postscript('highschoolfriendship_directed_statnet_model3_mcmcdiagnostics.eps')
mcmc.diagnostics(model3)
dev.off()

sink('highschoolfriendship_directed_statnet_model3.txt')
print( summary(model3) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model3, file = "model3.RData")

system.time( model3_gof <- gof(model3  ~ idegree + odegree + distance + espartners + dspartners + triadcensus)  )
print(model3_gof)
postscript('highschoolfriendship_directed_statnet_model3_gof.eps')
par(mfrow=c(3,2))
plot( model3_gof)
dev.off()

warnings()

