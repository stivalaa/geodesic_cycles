#!/usr/bin/env Rscript
###
### File:    statnetEstimateLazegaLawfirmFriendshipModel2.R
### Author:  Alex Stivala
### Created: July 2019
###
### Estimating ERGM parameters for a model for Lazega law firm friendship
### social network.
###
### Usage: statnetEstimateLazegaLawfirmFriendshipModel2.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'lazegalawfirmfriendship_statnet_model2.txt'
###   'lazegalawfirmfriendship_statnet_model2_mcmcdiagnostics.eps'
###   'lazegalawfirmfriendship_statnet_model2_gof.eps'
### WARNING: overwrites output files if they exist
###


source('load_lazega_lawfirm_data.R')

options(scipen=9999) # force decimals not scientific notation

gn <- load_lazega_lawfirm_data()

## data ios actually directed, convert to undirected here
## have to do this cumbersome way in statnet
### already undirected
###gn <- as.network.matrix(as.matrix.network(gn), directed=FALSE)


system.time( model2 <- ergm(gn ~ edges + gwdegree(0.1, fixed=TRUE) + gwesp(0.5, fixed=FALSE) + gwdsp(0.5, fixed=FALSE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY") +  nodefactor("OFFICE"), control = control.ergm(main.method="MCMLE", MCMC.interval=8192)) )

##not converged: system.time( model2 <- ergm(gn ~ edges + gwdegree(0.1, fixed=TRUE) + gwesp(0.5, fixed=FALSE) + gwdsp(0.5, fixed=FALSE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY") + nodefactor("PRACTICE") + nodefactor("OFFICE"), control = control.ergm(main.method="MCMLE", MCMC.interval=8192)) )

## not converged: system.time( model2 <- ergm(gn ~ edges + gwdegree(0.1, fixed=TRUE) + gwesp(0.5, fixed=FALSE) + gwdsp(0.5, fixed=FALSE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY") + nodefactor("PRACTICE") + nodefactor("OFFICE"), control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

##does not converge: system.time( model2 <- ergm(gn ~ edges + gwdegree(0.1, fixed=TRUE) + gwesp(0.5, fixed=FALSE) + gwdsp(0.5, fixed=FALSE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY") + nodefactor("PRACTICE") + nodefactor("OFFICE") + nodefactor("LAW_SCHOOL"), control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

##did not converge:system.time( model2 <- ergm(gn ~ edges + gwdegree(0.1, fixed=TRUE) + gwesp(0.5, fixed=FALSE) + gwdsp(0.5, fixed=FALSE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY") + nodefactor("STATUS") + nodefactor("PRACTICE") + nodefactor("OFFICE") + nodefactor("LAW_SCHOOL"), control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

## does not converge:system.time( model2 <- ergm(gn ~ edges + gwdegree(0.1, fixed=TRUE) + gwesp(0.5, fixed=FALSE) + gwdsp(0.5, fixed=FALSE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY") + nodefactor("STATUS") + nodefactor("PRACTICE") + nodefactor("OFFICE") + nodefactor("LAW_SCHOOL") +nodecov("AGE") + nodecov("SENIORITY"), control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

postscript('lazegalawfirmfriendship_statnet_model2_mcmcdiagnostics.eps')
mcmc.diagnostics(model2)
dev.off()

sink('lazegalawfirmfriendship_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model2, file = "model2.RData")

system.time( model2_gof <-  gof(model2  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model2_gof)
postscript('lazegalawfirmfriendship_statnet_model2_gof.eps')
par(mfrow=c(3,2))
plot( model2_gof)
dev.off()

warnings()

