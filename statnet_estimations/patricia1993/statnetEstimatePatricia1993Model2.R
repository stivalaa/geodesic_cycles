#!/usr/bin/env Rscript
###
### File:    statnetEstimatePatricia1993Model2.R
### Author:  Alex Stivala
### Created: July 2019
###
### Estimating ERGM parameters for a model for Patricia 1993 delusional
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
### Usage: statnetEstimatePatricia1993Model2.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'patricia1993_network_drawing_statnet.eps'
###   'patricia1993_statnet_model2.txt'
###   'patricia1993_statnet_model2_mcmcdiagnostics.eps'
###   'patricia1993_statnet_model2_gof.eps'
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


## do this after igraph things so as not to mess up namespaces
library(statnet)
library(intergraph)

gn <- asNetwork(g)

postscript('patricia1993_network_drawing_statnet.eps')
plot(gn, displaylabels=TRUE, label.cex=.6, vertex.col = gn %v% 'sphere')
dev.off()

system.time( model2 <- ergm(gn ~ edges + gwdegree(0.5,fixed=TRUE) + gwesp(0, fixed=TRUE)+ nodefactor('christian') + nodefactor('integrated')+  nodematch('christian') + nodematch('integrated'), control = control.ergm(main.method="MCMLE")) )

postscript('patricia1993_statnet_model2_mcmcdiagnostics.eps')
mcmc.diagnostics(model2)
dev.off()

sink('patricia1993_statnet_model2.txt')
print( summary(model2) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model2, file = "model2.RData")

system.time( model2_gof <-  gof(model2  ~ degree + distance + espartners + dspartners + triadcensus) )
print(model2_gof)
postscript('patricia1993_statnet_model2_gof.eps')
par(mfrow=c(3,3))
plot( model2_gof)
dev.off()

warnings()

