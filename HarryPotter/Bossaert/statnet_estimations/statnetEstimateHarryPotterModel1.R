#!/usr/bin/env Rscript
###
### File:    statnetEstimateHarryPotterModel1.R
### Author:  Alex Stivala
### Created: January 2023
###
### Estimating ERGM parameters for a model for Harry Potter peer spuport
### network from Harry Potter books. Reference for data:
###
### Goele Bossaert and Nadine Meidert (2013). 'We are only as strong 
### as we are united, as weak as we are divided'. A dynamic analysis 
### of the peer support networks in the Harry Potter books. 
### Open Journal of Applied Sciences, Vol. 3 No. 2, pp. 174-185. 
###
### Usage: statnetEstimateHarryPotterModel1.R
###
###
### Model and GoF output is to stdout, also writes output files to cwd:
###   'harrypotter_statnet_model1.txt'
###   'harrypotter_statnet_model1_mcmcdiagnostics.eps'
###   'harrypotter_statnet_model1_gof.eps'
### WARNING: overwrites output files if they exist
###


library(statnet)

source('load_harrypotter_data.R')

options(scipen=9999) # force decimals not scientific notation


source('load_harrypotter_data.R')


gn  <- load_harrypotter_data()
summary(gn)

# "Stepping" no longer used, only MCMLE or Stochastic-Approximation
# (Stepping is used within MCMLE automatically now presumably)

#"Warning: Model statistics 'gwdsp' are linear combinations of some set of preceding statistics at the current stage of the estimation. This may indicate that the model is nonidentifiable.":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=FALSE) + gwesp(.5, fixed=FALSE) + gwdsp(.5, fixed=FALSE),  control = control.ergm(main.method="MCMLE")) )

#" Unconstrained MCMC sampling did not mix at all. Optimization cannot continue":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=TRUE) + gwesp(.5, fixed=TRUE) + gwdsp(.5, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

# " Unconstrained MCMC sampling did not mix at all. Optimization cannot continue.":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=TRUE) + gwesp(.5, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

# Bad MCMC diagnostics:
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=TRUE) + gwesp(.5, fixed=TRUE),  control = control.ergm(main.method="Stochastic-Approximation")) )

#"Model statistics 'gwdeg.fixed.0' are not varying. This may indicate that the obs erved data occupies an extreme point in the sample space or that the estimation has reached a dead-end configuration.":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(0, fixed=TRUE) + gwesp(0, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(2.0, fixed=TRUE) + gwesp(2.0, fixed=TRUE),  control = control.ergm(main.method="MCMLE")) )

#"Unconstrained MCMC sampling did not mix at all. Optimization cannot continue.":
#system.time( model1 <- ergm(gn ~ edges + gwdegree(.5, fixed=TRUE) ,  control = control.ergm(main.method="MCMLE")) )
 
#" Unconstrained MCMC sampling did not mix at all. Optimization cannot continue.":
#system.time( model1 <- ergm(gn ~ edges + gwesp(.5, fixed=TRUE) ,  control = control.ergm(main.method="MCMLE")) )

# does not converge in 8 hours (iteration 7 of 60):
#system.time( model1 <- ergm(gn ~ edges + nodefactor('gender', base = 2)+  nodefactor('schoolyear') + nodefactor('house') + nodematch('gender') + nodematch('schoolyear') + nodematch('house') + gwdegree(0.5, fixed=TRUE) ,  control = control.ergm(main.method="MCMLE")) )

# "Unable to fit ar() even with order 1; this is likely to be due to insufficient sample size or a trend in the data.":
#system.time( model1 <- ergm(gn ~ edges + nodefactor('gender', base = 2)+  nodefactor('schoolyear') + nodefactor('house') + nodematch('gender') + nodematch('schoolyear') + nodematch('house') + gwesp(0.5, fixed=TRUE) ,  control = control.ergm(main.method="MCMLE")) )

# This one works, but get 
# "Observed statistic(s) nodefactor.schoolyear.1995 are at their smallest attainable values. Their coefficients will be fixed at -Inf.":
#system.time( model1 <- ergm(gn ~ edges + nodefactor('gender')+  nodefactor('schoolyear') + nodefactor('house') + nodematch('gender') + nodematch('schoolyear') + nodematch('house')  ,  control = control.ergm(main.method="MCMLE")) )

##> summary(factor(gn %v% "schoolyear"))
##1986 1987 1988 1989 1990 1991 1992 1993 1994 1995
##   1    3    3    9    5   26    3    2   10    2
##> summary(gn  ~ nodefactor('schoolyear', levels=-(10)))
##nodefactor.schoolyear.1986 nodefactor.schoolyear.1987
##                         1                         11
##nodefactor.schoolyear.1988 nodefactor.schoolyear.1989
##                         2                         40
##nodefactor.schoolyear.1990 nodefactor.schoolyear.1991
##                        11                        145
##nodefactor.schoolyear.1992 nodefactor.schoolyear.1993
##                        16                          3
##nodefactor.schoolyear.1994
##                         3
##>

system.time( model1 <- ergm(gn ~ edges + nodefactor('gender')+  nodefactor('schoolyear', levels = -c(6, 10)) + nodefactor('house') + nodematch('gender') + nodematch('schoolyear') + nodematch('house')  ,  control = control.ergm(main.method="MCMLE")) )

print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink('harrypotter_statnet_model1.txt')
print( summary(model1) ) ## sometimes need print(summary()), sometimes just summary() works (but not always). Why???
sink()

# do not do MCMC diagnostics for attr only model as MCMC not used "MCMC was not run or MCMC sample was not stored."
##postscript('harrypotter_statnet_model1_mcmcdiagnostics.eps')
##mcmc.diagnostics(model1)
##dev.off()

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
postscript('harrypotter_statnet_model1_gof.eps')
par(mfrow=c(3,2))
plot( model1_gof)
dev.off()

warnings()

