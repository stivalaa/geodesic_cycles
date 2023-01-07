#!/usr/bin/env Rscript
###
### File:    statnetEstimateKapfererTailorshopModel1.R
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
### Usage: statnetEstimateKapfererTailorshopModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'kapferertailorshop_statnet_model1.txt'
###   'kapferertailorshop_statnet_model1_mcmcdiagnostics.eps'
###   'kapferertailorshop_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###
## Run with
## ergm: version 3.6.0, created on 2016-03-24
## statnet: version 2016.4, created on 2016-03-23


library(statnet)


options(scipen=9999) # force decimals not scientific notation

data(kapferer)
gn <- kapferer

system.time( model1 <- ergm(gn ~ edges + gwdegree(0.25, fixed=TRUE) +  gwesp(0.25, fixed=TRUE) + gwdsp(0.25, fixed=TRUE), control = control.ergm(main.method="Stepping")) )

postscript('kapferertailorshop_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

sink('kapferertailorshop_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model1_gof)
postscript('kapferertailorshop_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

