#!/usr/bin/env Rscript
###
### File:    statnetEstimateGreysAnatomyModel5.R
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
### Usage: statnetEstimateGreysAnatomyModel5.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'greysanatomy_statnet_model5.txt'
###   'greysanatomy_statnet_model5_mcmcdiagnostics.eps'
###   'greysanatomy_statnet_model5_gof.eps'
### WARNING: overwrites output files if they exist
###


source('load_greysanatomy_data.R')

options(scipen=9999) # force decimals not scientific notation

gn <- load_greysanatomy_data()

##https://badhessian.org/2012/09/lessons-on-exponential-random-graph-modeling-from-greys-anatomy-hook-ups/
##Perhaps you're interested in the assortative mixture among roles in the hospital?
##Resident-resident sexual contacts (28) are the reference group,
##and unobserved pairings between positions (3-5, 9, 12-15, 17-21, 24, 27) are omitted.

system.time( model5 <- ergm(gn ~ edges + degree(1:3)  +  nodematch("sex") + absdiff("birthyear") + nodemix("position", base=c(3:5, 9, 12:15, 17:21, 24, 27, 28)) + nodematch("race", diff=TRUE, keep=c(1,3)), control = control.ergm(main.method="MCMLE", MCMC.burnin=100000, MCMC.interval=100000)) )
##system.time( model5 <- ergm(gn ~ edges + degree(1  ) +  nodefactor("sex") + nodematch("sex") + absdiff("birthyear"), control = control.ergm(main.method="MCMLE", MCMC.burnin=50000, MCMC.interval=50000)) )
postscript('greysanatomy_statnet_model5_mcmcdiagnostics.eps')
mcmc.diagnostics(model5)
dev.off()

sink('greysanatomy_statnet_model5.txt')
print( summary(model5) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model5, file = "model5.RData")

system.time( model5_gof <-  gof(model5  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model5_gof)
postscript('greysanatomy_statnet_model5_gof.eps')
par(mfrow=c(2,3))
plot( model5_gof)
dev.off()

warnings()

