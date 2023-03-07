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
    matrix multiplication with the "folklore algorithm for computing graph
    powers" [pp. 2672-2673].
    """
    powerGk = G.copy()
    for u in range(G.vcount()):
        for v in range(G.vcount()):
            if u != v and d_G[u][v] <= k and not powerGk.are_connected(u, v):
                powerGk.add_edges([(u,v)])
    return powerGk



def isInMk(Gk, uvtuple, testtuple):
    """ isInMk - auxiliary function for longestIsomeric cycle

    Parameters:
       Gk        - the Gk auxiliary graph in longestIsometriCycle
       uvtuple   - tuple (u, v) constructing Mk and M'k
       testtuple - tuple (x, y) to test for membership in Mk(u,v)

    Returns:
       True if testtuple is in the set M(uvtuple) else False
    
    """
    sys.stderr.write("TODO\n")
    return False


def longestIsometricCycle(G):
    """longestIsometricCycle - length of the longest isometric cycle in G
  
    Paramaters:
       G       - undirected graph object
   
    Returns:
       length of the longest isometric cycle in G

    Return the length of the longest isometric cycle, using the
    algorithm (Algorithm 4.1, "LIC - Longest Isometric Cycle" from:

      Lokshtanov, D. (2009). Finding the longest isometric cycle in a
      graph. Discrete Applied Mathematics, 157(12), 2670-2674.
    
    """
    ans = 0
    N = G.vcount()
    d_G = G.shortest_paths()
    if G.is_tree():
        return ans
    for k in range(3, N):
        ## Build the auxiliary graph Gk
        Vk = [(u, v) for u in range(N) for v in range(N)
              if d_G[u][v] == k // 2] # // operator is floor division
        Ek = [((u, v), (w, x)) for u in range(N) for v in range(N)
              for w in range(N) for x in range(N)
              if G.are_connected(u, w) and G.are_connected(v, x)]
        Gk = igraph.Graph()
        # note converting tuples to strings for vertex names as only
        # integer or strings (and not tuples) can be looked up as vertex IDs
        Gk.add_vertices([str(t) for t in Vk])
        Gk.add_edges([(str(t1), str(t2)) for (t1, t2) in Ek])
        ## compute the graph power Gk^floor(k/2)
        Gkpowerk2 = graphPower(G, k//2, d_G)
        # convert Vk to dict for fast testing of elements present in it
        Vk = dict.fromkeys(Vk)
        for u in range(N):
            for v in range(N):
                for x in range(N):
                    if ((u, v) in Vk and isInMk((v, u), (v, x)) and
                        Gkpowerk2.are_connected(str((u, v)), str((v, x)))):
                        ans = k
        return ans

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
