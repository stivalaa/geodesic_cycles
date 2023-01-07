#!/usr/bin/env Rscript
###
### File:    statnetEstimateHighSchoolFriendshipDirectedModel4.R
### Author:  Alex Stivala
### Created: September 2019
###
### Estimating ERGM parameters for a model for SocioPatterns
### high schol friendship social network (treated as directed).
###
### Usage: statnetEstimateHighSchoolFriendshipDirectedModel4.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'highschoolfriendship_directed_statnet_model4.txt'
###   'highschoolfriendship_directed_statnet_model4_mcmcdiagnostics.eps'
###   'highschoolfriendship_directed_statnet_model4_gof.eps'
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

system.time(model4 <- ergm(gn ~ edges + mutual + gwidegree(.2, fixed=TRUE) + gwodegree(.2, fixed=TRUE) + gwesp(.7, fixed=TRUE) + gwdsp(1.4, fixed=TRUE) + nodematch('class') + mutual(same='class') + nodematch('sex') + mutual('sex')  + nodeifactor('class') + nodeofactor('class'), control = control.ergm(main.method="MCMLE", MCMC.burnin=100000, MCMC.interval=16384)) )


postscript('highschoolfriendship_directed_statnet_model4_mcmcdiagnostics.eps')
mcmc.diagnostics(model4)
dev.off()

sink('highschoolfriendship_directed_statnet_model4.txt')
print( summary(model4) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model4, file = "model4.RData")

system.time( model4_gof <- gof(model4  ~ idegree + odegree + distance + espartners + dspartners + triadcensus)  )
print(model4_gof)
postscript('highschoolfriendship_directed_statnet_model4_gof.eps')
par(mfrow=c(3,3))
plot( model4_gof)
dev.off()

warnings()

