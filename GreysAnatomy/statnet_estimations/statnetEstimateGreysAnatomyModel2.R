#!/usr/bin/env Rscript
###
### File:    statnetEstimateGreysAnatomyModel2.R
### Author:  Alex Stivala
### Created: July 2019
###
### Estimating ERGM parameters for a model for Greys Anatomy 'hookups'
### social network.
###
### some code adapted from 
###  SNA in R Workshop
###  Administered at the University of Southern California
###  by Alex Leavitt & Joshua Clark
###  PhD students at the Annenberg School for Communication & Journalism
###   adapted from materials by Katya Ognyanova and the BadHessian blog
### https://github.com/alexleavitt/SNAinRworkshop
### https://badhessian.org/2012/09/lessons-on-exponential-random-graph-modeling-from-greys-anatomy-hook-ups/
###
### Usage: statnetEstimateGreysAnatomyModel2.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'greysanatomy_statnet_model2.txt'
###   'greysanatomy_statnet_model2_mcmcdiagnostics.eps'
###   'greysanatomy_statnet_model2_gof.eps'
### WARNING: overwrites output files if they exist
###


source('load_greysanatomy_data.R')

options(scipen=9999) # force decimals not scientific notation

gn <- load_greysanatomy_data()

# exceeded 18 hours time limit
system.time( model2 <- ergm(gn ~ edges + degree(1) + cycle(4)  + nodematch("sex"), control = control.ergm(main.method="Stepping", MCMC.burnin=100000, MCMC.interval=100000)) )

##did not mix at all: system.time( model2 <- ergm(gn ~ edges + degree(1:3) + cycle(4)  + nodematch("sex"), control = control.ergm(main.method="MCMLE", MCMC.burnin=100000, MCMC.interval=100000)) )

##exceeded 18 hours time limit: system.time( model2 <- ergm(gn ~ edges + degree(1:3) + cycle(4) +nodematch("sex") + absdiff("birthyear"), control = control.ergm(main.method="Stepping", MCMC.burnin=100000, MCMC.interval=100000)) )

##https://badhessian.org/2012/09/lessons-on-exponential-random-graph-modeling-from-greys-anatomy-hook-ups/
##Perhaps you're interested in the assortative mixture among roles in the hospital?
##Resident-resident sexual contacts (28) are the reference group,
##and unobserved pairings between positions (3-5, 9, 12-15, 17-21, 24, 27) are omitted.

## Unconstrained MCMC sampling did not mix at all.: system.time( model2 <- ergm(gn ~ edges + degree(1:3) + cycle(4) +nodematch("sex") + absdiff("birthyear") + nodemix("position", base=c(3:5, 9, 12:15, 17:21, 24, 27, 28)), control = control.ergm(main.method="MCMLE", MCMC.burnin=100000, MCMC.interval=100000)) )
## no triangles so this does not work: system.time( model2 <- ergm(gn ~ edges + degree(1:3) + triangle +  nodematch("sex") + absdiff("birthyear") + nodemix("position", base=c(3:5, 9, 12:15, 17:21, 24, 27, 28)), control = control.ergm(main.method="MCMLE", MCMC.burnin=100000, MCMC.interval=100000)) )
##system.time( model2 <- ergm(gn ~ edges + degree(1  ) +  nodefactor("sex") + nodematch("sex") + absdiff("birthyear"), control = control.ergm(main.method="MCMLE", MCMC.burnin=50000, MCMC.interval=50000)) )
postscript('greysanatomy_statnet_model2_mcmcdiagnostics.eps')
mcmc.diagnostics(model2)
dev.off()

sink('greysanatomy_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model2, file = "model2.RData")

system.time( model2_gof <-  gof(model2  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model2_gof)
postscript('greysanatomy_statnet_model2_gof.eps')
par(mfrow=c(3,2))
plot( model2_gof)
dev.off()

warnings()

