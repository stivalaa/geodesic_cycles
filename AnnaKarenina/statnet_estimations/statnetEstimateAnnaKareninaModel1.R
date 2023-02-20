#!/usr/bin/env Rscript
###
### File:    statnetEstimateAnnaKareninaModel1.R
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
### Usage: statnetEstimateAnnaKareninaModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'annakarenina_statnet_model1.txt'
###   'annakarenina_statnet_model1_mcmcdiagnostics.eps'
###   'annakarenina_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


library(igraph)
library(statnet)
library(intergraph)


options(scipen=9999) # force decimals not scientific notation

g <- read.graph('anna.graphml', format='graphml')
gn <- asNetwork(g)
print(gn)

## get the node which is the titular chararacter and so a hub
## adjacent to most of hte other nodes
## FIXME note Anna is only teh 5th most central (Degree) in this network... the most is Levin (and behind him Prince Oblonsky, Count Vrnonsky, and Kitty)
hero_node <- which(get.node.attr(gn, 'vertex.names') == 'LE') #Levin

## get edge list of edges adjacent to the hero node
## so we can use them as edgelist to fix as present in constraint
## NB have to transpose to get in right edge list format
hero_edges<-t(sapply( get.edges(gn, hero_node), function(e) c(e$inl, e$outl)))

system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=FALSE) + gwesp(.5, fixed=FALSE) + gwdsp(.5, fixed=FALSE), constraints = ~fixedas(present = hero_edges), control = control.ergm(main.method = 'Stepping', MCMC.interval=10000)) )


# Unconstrained MCMC sampling did not mix at all. Optimization cannot continue:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.9, fixed=TRUE)  , control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

# Unconstrained MCMC sampling did not mix at all. Optimization cannot continue:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.2, fixed=TRUE)  , control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

# did not mix at all:
#system.time( model1 <- ergm(gn ~ edges + degree(1:5) +  gwesp(0.5, fixed=FALSE), control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

# did not converge:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=FALSE) + gwdsp(0.5, fixed=FALSE) +  gwesp(0.5, fixed=FALSE), control = control.ergm(main.method="MCMLE", MCMC.interval=2048)) )

sink('annakarenina_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

## does not work with Stepping or fixed=FALSE:
##postscript('annakarenina_statnet_model1_mcmcdiagnostics.eps')
##mcmc.diagnostics(model1)
##dev.off()

save(gn, model1, file = "model1.RData")

system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus + model ) )
print(model1_gof)
postscript('annakarenina_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

