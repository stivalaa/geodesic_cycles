#!/usr/bin/env Rscript
###
### File:    statnetEstimateDavidCopperfieldModel1.R
### Author:  Alex Stivala
### Created: August 2019
###
### Estimating ERGM parameters for a model for Anna Karenina charcter
### interacgtion network. Reference for data:
###
###   Donald Knuth,
###   The Stanford Graph Base: A Platform for Combinatorial Computing,
###   ACM Press, 1993,  ISBN: 0201542757
###
### Usage: statnetEstimateDavidCopperfieldModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'davidcopperfield_statnet_model1.txt'
###   'davidcopperfield_statnet_model1_mcmcdiagnostics.eps'
###   'davidcopperfield_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


library(igraph)
library(statnet)
library(intergraph)


options(scipen=9999) # force decimals not scientific notation

g <- read.graph('david.graphml', format='graphml')
gn <- asNetwork(g)
print(gn)

## get the node which is the titular chararacter and so a hub
## adjacent to most of hte other nodes
hero_node <- which(get.node.attr(gn, 'vertex.names') == 'DC')

## get edge list of edges adjacent to the hero node
## so we can use them as edgelist to fix as present in constraint
## NB have to transpose to get in right edge list format
hero_edges<-t(sapply( get.edges(gn, hero_node), function(e) c(e$inl, e$outl)))

system.time( model1 <- ergm(gn ~ edges + gwdegree(.155, fixed=FALSE) + gwesp(1.38, fixed=FALSE) + gwdsp(.54, fixed=FALSE), constraints = ~fixedas(present = hero_edges), control = control.ergm(main.method = 'Stepping', MCMC.interval=500000)) )

## error in svd: dimension is: 0
##system.time( model1 <- ergm(gn ~ edges + gwdegree(.155, fixed=TRUE) + gwesp(1.38, fixed=TRUE) + gwdsp(.54, fixed=TRUE), constraints = ~fixedas(present = hero_edges), control = control.ergm(main.method = 'Stepping', MCMC.interval=500000)) )


## Unconstrained MCMC sampling did not mix at all. Optimization cannot continue.
##system.time( model1 <- ergm(gn ~ edges + gwdegree(.155, fixed=TRUE) + gwesp(1.38, fixed=TRUE) + gwdsp(.54, fixed=TRUE), constraints = ~fixedas(present = hero_edges), control = control.ergm(main.method = 'MCMLE', MCMC.interval=100000)) )

# GoF plot bad on geedesic especially, and nto diganostics from stepping:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.1, fixed=FALSE) + gwesp(1.4, fixed=FALSE) + gwdsp(.4, fixed=FALSE), constraints = ~fixedas(present = hero_edges), control = control.ergm(main.method = 'Stepping', MCMC.interval=10000)) )

#Approximate Hessian matrix is singular. DId not converged:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) +   gwesp(0.0, fixed=TRUE), control = control.ergm(main.method = "MCMLE")))

sink('davidcopperfield_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()


## does not work with Stepping and/or fixed=TRUE:
postscript('davidcopperfield_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

sink('davidcopperfield_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model1_gof)
postscript('davidcopperfield_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

