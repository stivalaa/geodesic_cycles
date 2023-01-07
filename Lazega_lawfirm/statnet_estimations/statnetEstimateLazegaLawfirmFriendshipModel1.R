#!/usr/bin/env Rscript
###
### File:    statnetEstimateLazegaLawfirmFriendshipModel1.R
### Author:  Alex Stivala
### Created: July 2019
###
### Estimating ERGM parameters for a model for Lazega law firm friendship
### social network.
###
### Usage: statnetEstimateLazegaLawfirmFriendshipModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'lazegalawfirmfriendship_statnet_model1.txt'
###   'lazegalawfirmfriendship_statnet_model1_mcmcdiagnostics.eps'
###   'lazegalawfirmfriendship_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


source('load_lazega_lawfirm_data.R')

options(scipen=9999) # force decimals not scientific notation

gn <- load_lazega_lawfirm_data()

## data ios actually directed, convert to undirected here
## have to do this cumbersome way in statnet
### already undirected
###gn <- as.network.matrix(as.matrix.network(gn), directed=FALSE)


system.time( model1 <- ergm(gn ~ edges + gwdegree(0.1, fixed=TRUE) + gwesp(0.5, fixed=FALSE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY"), control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

## still not good on ESP or degree: system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) + gwesp(0.5, fixed=TRUE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY"), control = control.ergm(main.method="MCMLE")) )

## still not good fit on ESP or even degree: system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY"), control = control.ergm(main.method="MCMLE")) )

## OK but not good fit on degree or ESP: system.time( model1 <- ergm(gn ~ edges + degree(0:6) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY"), control = control.ergm(main.method="MCMLE")) )

##system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) + gwdsp(0.5, fixed=TRUE) + gwesp(0.5, fixed=TRUE) + nodecov('SENIORITY') + nodefactor('PRACTICE') + nodefactor('OFFICE') + nodematch('PRACTICE') + nodematch('OFFICE')  , control = control.ergm(main.method="MCMLE", MCMC.burnin=50000, MCMC.interval=50000)) )

postscript('lazegalawfirmfriendship_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

sink('lazegalawfirmfriendship_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model1_gof)
postscript('lazegalawfirmfriendship_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

