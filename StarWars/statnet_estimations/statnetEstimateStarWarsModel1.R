#!/usr/bin/env Rscript
###
### File:    statnetEstimateStarWarsModel1.R
### Author:  Alex Stivala
### Created: January 2023
###
###
### ERGM estimation for Star Wars character interaction data from
###
### Evelina Gabasova. (2016). Star Wars social network (Version 1.0.1)
### [Data set]. Zenodo. http://doi.org/10.5281/zenodo.1411479
###
### Note this version Star Wars charcter interaction, all characters, 
### "merged" meaning Anakin and Darth Vader are the same node. See:
###
### http://evelinag.com/blog/2015/12-15-star-wars-social-network/
###
###
### Usage: statnetEstimateStarWarsModel1.R
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'starwars_statnet_model1.txt'
###   'starwars_statnet_model1_mcmcdiagnostics.eps'
###   'starwars_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


library(igraph)
library(statnet)
library(intergraph)


options(scipen=9999) # force decimals not scientific notation

g <- read.graph('../dkseries/starwars_edgelist.txt', format='edgelist', directed=FALSE)
gn <- asNetwork(g)
print(gn)


# "Stepping" no longer used, only MCMLE or Stochastic-Approximation
# (Stepping is used within MCMLE automatically now presumably)

# does not converge after 60 iterations;
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=FALSE) + gwesp(.5, fixed=FALSE) + gwdsp(.5, fixed=FALSE),  control = control.ergm(main.method="MCMLE")) )
#but get:
# 
# Monte Carlo Maximum Likelihood Results:
# 
#                                 Estimate                Std. Error MCMC %
# edges          -1.0046797270314238303968  0.6866720374913103386305      0
# gwdegree       -0.0242007087027853486083  2.1064258370231208061796      0
# gwdegree.decay  0.0002080807598103408653 31.3726487669804612323787      0
# gwesp          -0.0479182422512828345984  0.1721458071498934150334      0
# gwesp.decay     0.0000000000000000002213 20.2578195035677026680787      0
# gwdsp          -0.3465945249259154148369  0.0915157382628042637140      0
# gwdsp.decay     0.0711226009208505149939  0.3803992219265829866082      0
#                z value Pr(>|z|)    
# edges           -1.463 0.143436    
# gwdegree        -0.011 0.990833    
# gwdegree.decay   0.000 0.999995    
# gwesp           -0.278 0.780737    
# gwesp.decay      0.000 1.000000    
# gwdsp           -3.787 0.000152 ***
# gwdsp.decay      0.187 0.851685    

#Unconstrained MCMC sampling did not mix at all. Optimization cannot continue.:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0, fixed=TRUE) + gwesp(0, fixed=TRUE) + gwdsp(.1, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) + gwesp(0.5, fixed=TRUE) + gwdsp(.5, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) + gwesp(0.5, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.0, fixed=TRUE) + gwesp(0.0, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE) + gwesp(2.0, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) ,  control = control.ergm(main.method="MCMLE")) )

#degenerate:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) ,  control = control.ergm(main.method="Stochastic-Approximation")) )

#bad mcmc diag p-values:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) +gwesp(0.5, fixed=TRUE) ,  control = control.ergm(main.method="Stochastic-Approximation")) )

# OK but poor esp gof:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.0, fixed=TRUE) +gwesp(0.0, fixed=TRUE) ,  control = control.ergm(main.method="Stochastic-Approximation")) )

#bad mcmc diag p-values:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.0, fixed=TRUE) +gwesp(0.5, fixed=TRUE) ,  control = control.ergm(main.method="Stochastic-Approximation")) )


#bad mcmc diag plot:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.0, fixed=TRUE) +gwesp(0.1, fixed=TRUE) ,  control = control.ergm(main.method="Stochastic-Approximation")) )

#bad mcmc diag plot:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.0, fixed=TRUE) +gwesp(0.1, fixed=TRUE) + gwdsp(0.1, fixed=TRUE) ,  control = control.ergm(main.method="Stochastic-Approximation")) )

#bad mcmc diag plot:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.1, fixed=TRUE) +gwesp(0.1, fixed=TRUE) + gwdsp(0.1, fixed=TRUE) ,  control = control.ergm(main.method="Stochastic-Approximation")) )

#bad mcmc diag pvalues and plot:
system.time( model1 <- ergm(gn ~ edges + gwdegree(1.1, fixed=TRUE) +gwesp(0.1, fixed=TRUE) + gwdsp(0.1, fixed=TRUE) ,  control = control.ergm(main.method="Stochastic-Approximation")) )


print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink('starwars_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

postscript('starwars_statnet_model1_mcmcdiagnostics.eps')
mcmc.diagnostics(model1)
dev.off()

save(gn, model1, file = "model1.RData")

# Always get warning on GoF, "In gof.formula(object = object$formula, coef = coef, GOF = GOF,  : No parameter values given, using 0."
# (ergm version  4.3.2 (2022-11-21)),
# but this seems normal now, even in tutorial (with no comment/explanation)
# at https://statnet.org/workshop-ergm/ergm_tutorial.html
# [dated 2022-07-06, accessed 2023-01-17]
#system.time( model1_gof <-  gof(model1 ~ degree + distance + espartners + dspartners + triadcensus + model ) )

# seems it has to be done this way instead now:
system.time( model1_gof <-  gof(model1, GOF = ~ degree + distance + espartners + dspartners + triadcensus + model ) )

print(model1_gof)
postscript('starwars_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

