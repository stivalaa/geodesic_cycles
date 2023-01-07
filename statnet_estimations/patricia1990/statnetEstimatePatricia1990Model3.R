#!/usr/bin/env Rscript
###
### File:    statnetEstimatePatricia1990Model3.R
### Author:  Alex Stivala
### Created: July 2019
###
### Estimating ERGM parameters for a model for Patricia 1990 delusional
### social network.x
###
### Citations for data:
###
### David, Anthony, Roisin Kemp, Ladé Smith and Thomas Fahy. 1996.  "Split
### Minds: Multiple Personality and Schizophrenia." Pp. 122-146 in Method
### in Madness: Case Studies in Neuropsychiatry, edited by Peter
### W. Halligan and John C. Marshall.
###
### Martin,J.L.(2017).The Structure of Node and Edge Generation in a
### Delusional Social Network. Journal of Social Structure, 18(1),1-21.
### cdoi:10.21307/joss-2018-005.
###  Neuroscience Abstracts 30:921.9.
###
### Usage: statnetEstimatePatricia1990Model3.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'patricia1990_statnet_model3.txt'
###   'patricia1990_statnet_model3_mcmcdiagnostics.eps'
###   'patricia1990_statnet_model3_gof.eps'
### WARNING: overwrites output files if they exist
###

library(igraph)

options(scipen=9999) # force decimals not scientific notation

g = read.graph('patricia1990.graphml', format='graphml')

## do this after igraph things so as not to mess up namespaces
library(statnet)
library(intergraph)

gn <- asNetwork(g)

## putting both degree(2) and degree(3) gets singular Hessian matrix, bad model
## due to highly correlated terms so cannot estimate std. error.
## So try with altkstar and curved ERGM estimating lambda instead
### but not get bogus results, -ve AIC and BIC, -ve decay, etc. makes no sense
system.time( model3 <- ergm(gn ~ edges + degrange(from = 2, to = 3) + gwesp(0, fixed=TRUE), control = control.ergm(main.method="MCMLE")) )

postscript('patricia1990_statnet_model3_mcmcdiagnostics.eps')
mcmc.diagnostics(model3)
dev.off()

sink('patricia1990_statnet_model3.txt')
print( summary(model3) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model3, file = "model3.RData")

system.time( model3_gof <-  gof(model3  ~ degree + distance + espartners + dspartners + triadcensus) )
print(model3_gof)
postscript('patricia1990_statnet_model3_gof.eps')
par(mfrow=c(3,3))
plot( model3_gof)
dev.off()

warnings()

