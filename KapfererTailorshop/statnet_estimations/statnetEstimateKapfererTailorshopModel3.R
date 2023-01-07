#!/usr/bin/env Rscript
###
### File:    statnetEstimateKapfererTailorshopModel3.R
### Author:  Alex Stivala
### Created: August 2019
###
### Estimating ERGM parameters for a model for Kapferer tailor shop
### social network. Reference for data:
###
###  Kapferer, Bruce (1972), Strategy and Transaction in an African Factory, 
###  Manchester University Press.
###
### Model from:
###
###   Hummel, R. M., Hunter, D. R., & Handcock, M. S. (2012).
###   Improving simulation-based algorithms for fitting ERGMs.
###   Journal of Computational and Graphical Statistics, 21(4), 920-939.
###
### Usage: statnetEstimateKapfererTailorshopModel3.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'kapferertailorshop_statnet_model3.txt'
###   'kapferertailorshop_statnet_model3_mcmcdiagnostics.eps'
###   'kapferertailorshop_statnet_model3_gof.eps'
### WARNING: overwrites output files if they exist
###
## Run with
## ergm: version 3.6.0, created on 2016-03-24
## statnet: version 2016.4, created on 2016-03-23


library(statnet)


options(scipen=9999) # force decimals not scientific notation

data(kapferer)
gn <- kapferer

system.time( model3 <- ergm(gn ~ edges + gwdegree(0.25, fixed=TRUE) + gwesp(0.5, fixed=TRUE) + gwdsp(0.5, fixed=TRUE) , control = control.ergm(main.method="Stepping")) )

postscript('kapferertailorshop_statnet_model3_mcmcdiagnostics.eps')
mcmc.diagnostics(model3)
dev.off()

sink('kapferertailorshop_statnet_model3.txt')
print( summary(model3) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model3, file = "model3.RData")

system.time( model3_gof <-  gof(model3  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model3_gof)
postscript('kapferertailorshop_statnet_model3_gof.eps')
par(mfrow=c(3,2))
plot( model3_gof)
dev.off()

warnings()

