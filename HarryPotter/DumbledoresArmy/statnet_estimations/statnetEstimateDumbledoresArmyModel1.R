#!/usr/bin/env Rscript
###
### File:    statnetEstimateDumbledoresArmyModel1.R
### Author:  Alex Stivala
### Created: January 2023
###
### Estimating ERGM parameters for a model for Dumbledore's Army
### trust network from Harry Potter books. Rference for data:
###
##$# Everton, S., Everton, T., Green, A., Hamblin, C., & Schroeder, R. (2022). Strong ties and where to find them: or, why Neville and Bellatrix might be more important than Harry and Tom. Social Network Analysis and Mining, 12(1), 1-18.
###
### Usage: statnetEstimateDumbledoresArmyModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'dumbledoresarmy_statnet_model1.txt'
###   'dumbledoresarmy_statnet_model1_mcmcdiagnostics.eps'
###   'dumbledoresarmy_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


library(igraph)
library(statnet)
library(intergraph)


options(scipen=9999) # force decimals not scientific notation

g <- read.graph('../dkseries/dumbledoresarmy_edgelist.txt', format='edgelist', directed=FALSE)
gn <- asNetwork(g)
print(gn)


# "Stepping" no longer used, only MCMLE or Stochastic-Approximation
# (Stepping is used within MCMLE automatically now presumably)

# with fixed=FALSE fails in phase 3 "Error in trust(objfun = loglikelihoodfn.trust, parinit = guess, rinit = 1,  : parinit not all finite ":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=FALSE) + gwesp(.5, fixed=FALSE) + gwdsp(.5, fixed=FALSE),  control = control.ergm(main.method="Stochastic-Approximation")) )


#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue."#:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=TRUE) + gwesp(.5, fixed=TRUE) + gwdsp(.5, fixed=TRUE)) )
#does not converge within 6 hours with fixed=FALSE:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=FALSE) + gwesp(.5, fixed=FALSE) + gwdsp(.5, fixed=FALSE)) )

# MCMC diagnostics bad, bad GoF:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=TRUE) + gwesp(.5, fixed=TRUE) + gwdsp(.5, fixed=TRUE),  control = control.ergm(main.method="Stochastic-Approximation")) )

# MCMC diagnostics bad, bad GoF:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0, fixed=TRUE) + gwesp(0, fixed=TRUE) + gwdsp(.5, fixed=TRUE),  control = control.ergm(main.method="Stochastic-Approximation")) )

# MCMC diagnostics bad on gwesp, bad GoF (degenrate)
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE) + gwesp(2.00, fixed=TRUE) + gwdsp(2.0, fixed=TRUE),  control = control.ergm(main.method="Stochastic-Approximation")) )

# "Error in snearPD(V) : Matrix x has negative elements on the diagonal.":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE) + gwesp(0.1, fixed=TRUE) + gwdsp(2.0, fixed=TRUE),  control = control.ergm(main.method="Stochastic-Approximation")) )

# "Error in snearPD(V) : Matrix x has negative elements on the diagonal.":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE) + gwesp(5.0, fixed=TRUE) + gwdsp(2.0, fixed=TRUE),  control = control.ergm(main.method="Stochastic-Approximation")) )

# Degenerate model (bad MCMC diagnostics and GoF model terms):
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE) + gwesp(1.0, fixed=TRUE) + gwdsp(2.0, fixed=TRUE),  control = control.ergm(main.method="Stochastic-Approximation")) )

# Degenerate model (bad MCMC diagnostics and GoF model terms):
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE) + gwdsp(2.0, fixed=TRUE),  control = control.ergm(main.method="Stochastic-Approximation")) )

#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue.":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE) + gwdsp(2.0, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

# MCMC diagnostics good, GoF OK except ESP because of obs peak at 6 (degree dist also not that great)
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

# not converging after 5 hours:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=FALSE),  control = control.ergm(main.method="MCMLE")) )


# MCMC diagnostics good, GoF OK except ESP because of obs peak at 6 (degree dist also not that great)
system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) + gwesp(0.5, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

# "Unconstrained MCMC sampling did not mix at all. Optimization cannot continue.":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0.5, fixed=TRUE) + gwesp(2.0, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

sink('dumbledoresarmy_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

postscript('dumbledoresarmy_statnet_model1_mcmcdiagnostics.eps')
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
postscript('dumbledoresarmy_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

