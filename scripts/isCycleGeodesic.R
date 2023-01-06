##
## File:    isCycleGeodesic.R
## Author:  Alex Stivala
## Created: December 2022
##
## Functions for testing if cycles are geodesic (also known as isometric)
## cycles. 
##
## A geodesic cycle is a cycle such that the distance along the cycle
## between any pair of nodes in the cycle is the same as their distance 
## in the graph.
##
## References:
##
## Benjamini, I., Hoppen, C., Ofek, E., Prałat, P., & Wormald, N. (2011).
## Geodesics and almost geodesic cycles in random regular graphs. 
## Journal of Graph Theory, 66(2), 115-136.
##
## Li, Y., & Shi, L. (2018). Geodesic cycles in random graphs. 
## Discrete Mathematics, 341(5), 1275-1281.
##
## Lokshtanov, D. (2009). Finding the longest isometric cycle in a graph.
## Discrete Applied Mathematics, 157(12), 2670-2674.
##
## Negami, S., & Xu, G. H. (1986). Locally geodesic cycles in 
## 2-self-centered graphs. Discrete mathematics, 58(3), 263-268.
##

library(igraph)

##
## isCycleGeodesic - test if a cycle in a graph g is a geodesic cycle
##
## Paramters:
##    g           - undirected graph object
##    distmatrix  - precomputed distance matrix distances(g)
##    cycle       - nodes in a cycle specified as a vector of nodes in g,
##                  IN ORDER along cycle, so that distance 
##                  in cycle is just cycle difference of their indices
##
## Returns:
##    TRUE if the cycle is geodesic else FALSE
##
## A geodesic cycle is a cycle such that the distance along the cycle
## between any pair of nodes in the cycle is the same as their distance 
## in the graph.
##
## This function tests if the cycle is geodesic simply using the definition.
## Note it does NOT test if the input cycle is actually a cycle, this is a
## precondition.
##
##
isCycleGeodesic <- function(g, distmatrix, cycle) {
  nodepairs <- combn(cycle, 2) # pairs of nodes in the cycle
  ## geodesic distance of each pair of nodes in cycle
  graph_dists <- mapply(function(u, v) distmatrix[u, v], 
                         nodepairs[1,], nodepairs[2,])
  ## get indices in cycle vector of nodes in nodepairs
  ##nodepair_indices_OLD <- apply(nodepairs, 2, function(x) match(x, cycle))
  nodepair_indices <- matrix(match(nodepairs, cycle), nrow=2)
  ##stopifnot(all(nodepair_indices_OLD == nodepair_indices)) 
  ## and now get distance along cycle of each pair of nodes in cycle,
  ## which is just cycle difference min(abs(i-j), k - abs(i-j))
  ## of their indices i,j, where k is cycle length
  k <- length(cycle)
  cycle_dists <- mapply(function(i, j) min(abs(i-j), k - abs(i-j)),
                        nodepair_indices[1,], nodepair_indices[2,])
  return(all(graph_dists == cycle_dists))
}

