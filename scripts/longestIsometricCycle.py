#!/usr/bin/env python3
##############################################################################
#
# File:    longestIsometricCycle.py
# Author:  Alex Stivala
# Created: March 2023
#
##############################################################################
"""Usage: longestIsometricCycle.py graph_egelist.txt
  
  
   Read graph in edgelist format (nodes must be 0..N-1) from graph_edgelist.txt
   and output length of the longest isometric cycle, using the
   algorithm (Algorithm 4.1, "LIC - Longest Isometric Cycle" from:

      Lokshtanov, D. (2009). Finding the longest isometric cycle in a
      graph. Discrete Applied Mathematics, 157(12), 2670-2674.

   An isometric cycle is a cycle in which the distance between two
   vertices alogn the cycle is equal to their graph distance (shortest path).
   This is also known as a geodesic cycle; for literature overview
   of different terms for this, see:

     Stivala, A. (2020). Geodesic cycle length distributions in delusional
     and other social networks. Journal of Social Structure, 21(1):35-76
     https://doi.org/10.21307/joss-2020-002

     Stivala, A. (2023). Geodesic cycle length distributions in
     fictional character networks.  [Unpublished manuscript.]

"""
import sys
import igraph

def graphPower(G, k, d_G):
    """graphPower - return the graph power of graph G to the integer power k
  
    Paramaters:
       G       - undirected graph object
       k       - integer
       d_G     - precomputed distance matrix for G, G.shortest_paths().
   
    Returns:
       a new graph, the graph G^k

    The graph power G^k : on the same node set as G, two distinct
    nodes u and v are adjacent in G^k iff the shortest path distance
    between u and v in G is at most k.

    G^k = (V(G), {(u, v) : d_G(u, v) <= k})


    See https://mathworld.wolfram.com/GraphPower.html
    
    NetworkX contains a function to do this power(G,k)
    https://networkx.org/documentation/stable/reference/algorithms/generated/networkx.algorithms.operators.product.power.html
    but it is not documented what algorithm it uses.  igraph does not
    (as of March 2023, R/igraph 1.3.5, python/igraph 0.10.2, C/igraph
    0.10.4) have such a function explicitly, although the C library
    has igraph_connect_neibhorhood()
    https://igraph.org/c/doc/igraph-Operators.html#igraph_connect_neighborhood
    which is a (slow) in-place implementation of graph power; see also
    https://github.com/igraph/igraph/issues/2063
    but in either case this does not appear to be available the Python (or R)
    interface.

    This is a simple inefficient implementation. As noted in
    Lokshtanov (2009) it can more efficiently be implemented using
    matrix multiplication with the "folklore algorihtm for computing graph
    powers" [pp. 2672-2673].
    """
    powerGk = G.copy()
    for u in range(G.vcount()):
        for v in range(G.vcount()):
            if u != v and d_G[u][v] <= k and not powerGk.are_connected(u, v):
                powerGk.add_edges([(u,v)])
    return powerGk
    
   

#-----------------------------------------------------------------------------
#
# main
#
#-----------------------------------------------------------------------------

def usage(progname):
    """
    print usage msg and exit
    """
    sys.stderr.write("usage: " + progname + " graph_edgelist.txt\n")
    sys.exit(1)


def main():
    """
    See usage message in module header block
    """
    if (len(sys.argv) != 2):
        usage(sys.argv[0])

    graph_edgelist_filename = sys.argv[1]

    g = igraph.Graph.Read(graph_edgelist_filename, format='edgelist',
                          directed=False)
    
if __name__ == "__main__":
    main()
