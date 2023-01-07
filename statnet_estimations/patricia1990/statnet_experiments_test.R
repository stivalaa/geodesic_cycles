library(igraph )


g = read.graph('patricia1990.graphml', format='graphml')
               
library(intergraph)
library(statnet)


system.time( model1 <- ergm(gn ~ edges + degree(2) + gwesp) )
mcmc.diagnostics(model2)
system.time( model1_gof <-  gof(model1  ~ degree + distance + espartners + dspartners + triadcensus) )


system.time( model2 <- ergm(gn ~ edges + degree(c(3)) + gwesp) )
mcmc.diagnostics(model2)
system.time( model2_gof <-  gof(model2  ~ degree + distance + espartners + dspartners + triadcensus) )



system.time( model3 <- ergm(gn ~ edges + degree(c(3)) + gwesp(0,fixed=TRUE) , control = control.ergm(main.method="MCMLE")) )
mcmc.diagnostics(model3)
system.time( model3_gof <-  gof(model3  ~ degree + distance + espartners + dspartners + triadcensus) )



gsim <- simulate(model3, nsim=1000)

# https://lists.nongnu.org/archive/html/igraph-help/2009-04/msg00126.html
count_subgraph_isomorphisms(graph.ring(10), g) / (10*2)
cycle10dist <- (unlist(lapply(gsim, function(x) count_subgraph_isomorphisms(graph.ring(10), asIgraph(x))/(10*2))))
