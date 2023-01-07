#!/usr/bin/env Rscript
###
### File:    statnetEstimateLazegaLawfirmFriendshipModel3.R
### Author:  Alex Stivala
### Created: July 2019
###
### Estimating ERGM parameters for a model for Lazega law firm friendship
### social network.
###
### Usage: statnetEstimateLazegaLawfirmFriendshipModel3.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'lazegalawfirmfriendship_statnet_model3.txt'
###   'lazegalawfirmfriendship_statnet_model3_mcmcdiagnostics.eps'
###   'lazegalawfirmfriendship_statnet_model3_gof.eps'
### WARNING: overwrites output files if they exist
###


source('load_lazega_lawfirm_data.R')

options(scipen=9999) # force decimals not scientific notation

gn <- load_lazega_lawfirm_data()

## data ios actually directed, convert to undirected here
## have to do this cumbersome way in statnet
### already undirected
###gn <- as.network.matrix(as.matrix.network(gn), directed=FALSE)


system.time( model3 <- ergm(gn ~ edges + degree(0:10) + gwesp(0.5, fixed=FALSE) + gwdsp(0.5, fixed=FALSE) +  nodematch("STATUS") + nodematch("PRACTICE") + nodematch("OFFICE") + nodematch("GENDER") + nodematch("LAW_SCHOOL") + absdiff("AGE")+ absdiff("SENIORITY"), control = control.ergm(main.method="MCMLE")) )

postscript('lazegalawfirmfriendship_statnet_model3_mcmcdiagnostics.eps')
mcmc.diagnostics(model3)
dev.off()

sink('lazegalawfirmfriendship_statnet_model3.txt')
print( summary(model3) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model3, file = "model3.RData")

system.time( model3_gof <-  gof(model3  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model3_gof)
postscript('lazegalawfirmfriendship_statnet_model3_gof.eps')
par(mfrow=c(3,2))
plot( model3_gof)
dev.off()

warnings()

