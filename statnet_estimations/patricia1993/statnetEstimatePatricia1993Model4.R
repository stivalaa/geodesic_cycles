#!/usr/bin/env Rscript
###
### File:    statnetEstimatePatricia1993Model4.R
### Author:  Alex Stivala
### Created: September 2019
###
### Estimating ERGM parameters for a model for Patricia 1993 delusional
### social network.x
###
### Citations for data:
###
### David, Anthony, Roisin Kemp, Lad� Smith and Thomas Fahy. 1996.  "Split
### Minds: Multiple Personality and Schizophrenia." Pp. 122-146 in Method
### in Madness: Case Studies in Neuropsychiatry, edited by Peter
### W. Halligan and John C. Marshall.
###
### Martin,J.L.(2017).The Structure of Node and Edge Generation in a
### Delusional Social Network. Journal of Social Structure, 18(1),1-21.
### cdoi:10.21307/joss-2018-005.
###  Neuroscience Abstracts 30:921.9.
###
### Usage: statnetEstimatePatricia1993Model4.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'patricia1993_statnet_model4.txt'
###   'patricia1993_statnet_model4_mcmcdiagnostics.eps'
###   'patricia1993_statnet_model4_gof.eps'
### WARNING: overwrites output files if they exist
###

library(igraph)

options(scipen=9999) # force decimals not scientific notation

g = read.graph('patricia1993.graphml', format='graphml')
attrs <- read.table('patricia1993_attributes.txt', stringsAsFactors= FALSE, header=TRUE)
V(g)$integrated <- attrs$integrated
V(g)$christian <- attrs$christian
V(g)$age <- attrs$number
V(g)$sphere <- attrs$sphere
V(g)$behind <- attrs$behind


## do this after igraph things so as not to mess up namespaces
library(statnet)
library(intergraph)

gn <- asNetwork(g)


system.time( model4 <- ergm(gn ~ edges + gwdegree(0.5,fixed=TRUE) + gwesp(0, fixed=TRUE)+ nodefactor('christian') + nodefactor('integrated')+ nodefactor('sphere') + nodematch('christian') + nodematch('integrated') + nodematch('sphere') + nodefactor('behind'), control = control.ergm(main.method="MCMLE")) )

## HEssian is singular, probably because 'behind' is a component
##system.time( model4 <- ergm(gn ~ edges + gwdegree(0.5,fixed=TRUE) + gwesp(0, fixed=TRUE)+ nodefactor('christian') + nodefactor('integrated')+ nodefactor('sphere') + nodematch('christian') + nodematch('integrated') + nodematch('sphere') + nodefactor('behind') + nodematch('behind'), control = control.ergm(main.method="MCMLE")) )

postscript('patricia1993_statnet_model4_mcmcdiagnostics.eps')
mcmc.diagnostics(model4)
dev.off()

sink('patricia1993_statnet_model4.txt')
print( summary(model4) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model4, file = "model4.RData")

system.time( model4_gof <-  gof(model4  ~ degree + distance + espartners + dspartners + triadcensus) )
print(model4_gof)
postscript('patricia1993_statnet_model4_gof.eps')
par(mfrow=c(3,3))
plot( model4_gof)
dev.off()

warnings()

