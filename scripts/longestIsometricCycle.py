#!/usr/bin/env python3
##############################################################################
#
# File:    longestIsometricCycle.py
# Author:  Alex Stivala
# Created: March 2023
#
##############################################################################
"""Usage: longestIsometricCycle.py [-v] [-d] graph_egelist.txt

   Options:
       -v : verbose. progress and other output to stderr
       -d : debug. debug output to stderr
  
   Read graph in edgelist format (nodes must be 0..N-1) from graph_edgelist.txt
   and output length of the longest isometric cycle, using the Lokshtanov
   algorithm (Algorithm 4.1, "LIC - Longest Isometric Cycle") from:

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

Developed with python/igraph 0.9.9 under Python 3.9.10 (Cygwin Windows 10) and
python/igraph 0.10.2 under Python 3.9.0 (Linux CentOS 8.2.2004)
"""
import sys
import getopt
import igraph

def graphPower(G, k, d_G = None):
    """graphPower - return the graph power of graph G to the integer power k
  
    Paramaters:
       G       - undirected graph object
       k       - integer
       d_G     - precomputed distance matrix for G, G.shortest_paths().
                 If None (default) then computed here.
   
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
    ## TODO would be much faster to build list of edges and add all at
    ## once:
    ## https://stackoverflow.com/questions/13974279/igraph-why-is-add-edge-function-so-slow-ompared-to-add-edges
    ## but we need some way to not end up with multi-edges (which
    ## add_edge() or add_edges() does not seem to have an option to
    ## only add if not already there). Simple way be to simply
    ## make the edgelist a set.
    if d_G is None:
        d_G = G.shortest_paths()
    powerGk = G.copy()
    for u in range(G.vcount()):
        for v in range(G.vcount()):
            if u != v and d_G[u][v] <= k and not powerGk.are_connected(u, v):
                ## in the absence of more efficient way (see above TODO)
                ## add_edges() is supposedly more efficient than add_edge()
                ## even for a single edge since we don't need the
                ## returned Edge object here
                ## https://igraph.org/python/doc/api/igraph.Graph.html#add_edge
                powerGk.add_edges([(u,v)])
    return powerGk



def isInMk(G, Gk, Vk, k, uvtuple, testtuple):
    """ isInMk - auxiliary function for longestIsomeric cycle

    Parameters:
       G         - graph G in which we are finding longest isometric cycle
       Gk        - the Gk auxiliary graph in longestIsometriCycle
       Vk        - dict or set of tuples naming nodes of Gk for fast lookup
       k         - the current candidate isometric cycle length k
       uvtuple   - tuple (u, v) [node in Gk] constructing Mk and M'k
       testtuple - tuple (x, y) to test for membership in Mk(u,v)

    Returns:
       True if testtuple is in the set M(uvtuple) else False
    
    """
    if k % 2 == 0: # case for even k
        return testtuple == uvtuple
    else:          # case for odd k
        (u, v) = uvtuple
        # TODO we can do this (as noted in paper) without actually
        # constructing Mprimek
        Mprimek = set([(u, x) for x in range(G.vcount()) if (u, x) in Vk and
                   G.are_connected(v, x)])
        return testtuple in Mprimek


def longestIsometricCycle(G, verbose = False, debug = False):
    """longestIsometricCycle - length of the longest isometric cycle in G
  
    Paramaters:
       G       - undirected graph object
       verbose - Boolean, True to output progress messages to stderr
       debug   - Boolean, True to output debugging data to stderr
   
    Returns:
       length of the longest isometric cycle in G

    Return the length of the longest isometric cycle, using the
    algorithm (Algorithm 4.1, "LIC - Longest Isometric Cycle" from:

      Lokshtanov, D. (2009). Finding the longest isometric cycle in a
      graph. Discrete Applied Mathematics, 157(12), 2670-2674.
    
    """
    assert not G.is_directed()
    assert G.is_simple()
    ans = 0
    N = G.vcount()
    d_G = G.shortest_paths()
    if G.is_tree():
        return ans
    for k in range(3, N+1): # Python zero based range for 3, 4, ..., N
        if verbose:
            sys.stderr.write("k = %d\n" % k)
        ## Build the auxiliary graph Gk
        Vk = [(u, v) for u in range(N) for v in range(N)
              if d_G[u][v] == k // 2] # // operator is floor division
        if debug:
            sys.stderr.write('len(Vk) = %d\n' % len(Vk))
            sys.stderr.write('Vk = %s\n' % str(Vk))
        VK = set(Vk)  # a set is basically a dict, O(1) lookup
        if debug:
            sys.stderr.write('set len(Vk) = %d\n' % len(Vk))
        Ek = [((u, v), (w, x)) for (u, v) in Vk for (w, x) in Vk if
                  (u, v) != (w, x) and
                  G.are_connected(u, w) and G.are_connected(v, x)]
        if debug:
            sys.stderr.write('len(Ek) = %d\n' % len(Ek))
            sys.stderr.write("Ek = %s\n" % str(Ek))
        Ek = set(Ek)
        if debug:
            sys.stderr.write('set len(Ek) = %d\n' % len(Ek))            
        Gk = igraph.Graph()
        # note converting tuples to strings for vertex names as only
        # integer or strings (and not tuples) can be looked up as vertex IDs
        Gk.add_vertices([str(t) for t in Vk])
        if debug:
            sys.stderr.write(str([(str(t1), str(t2)) for (t1, t2) in Ek]) + '\n')
        Gk.add_edges([(str(t1), str(t2)) for (t1, t2) in Ek])
        if debug:
            sys.stderr.write(Gk.summary() + '\n')
        assert not any(Gk.is_loop())
        assert not Gk.has_multiple()
        #already done by previous two asserts: assert Gk.is_simple()
        ## compute the graph power Gk^floor(k/2)
        Gkpowerk2 = graphPower(Gk, k//2)
        assert Gkpowerk2.is_simple()
        if debug:
            sys.stderr.write("Gkpowerk2.density() = %g,  Gk.density() = %g\n" % (Gkpowerk2.density(), Gk.density()))
        assert Gk.ecount() == 0 or (Gkpowerk2.density() >= Gk.density())
        for u in range(N):
            for v in range(N):
                for x in range(N):
                    if ((u, v) in Vk and
                        isInMk(G, Gk, Vk, k, (v, u), (v, x)) and
                        Gkpowerk2.are_connected(str((u, v)), str((v, x)))):
                        if verbose and k != ans:
                            sys.stderr.write('ans = %d\n' % k)
                        ans = k
                        if debug:
                            sp = Gk.shortest_paths(str((u, v)), str((v, x)))
                            # only got shortest path between two nodes
                            # so must be list of length 1 nested
                            assert len(sp) == 1
                            assert len(sp[0]) == 1
                            sp = sp[0][0]
                            if k % 2 == 0: # even k case
                                sys.stderr.write("even k = %d: u = %d, v = %d, x = %d, d_Gk[(u,v)][(v,x)] = %d\n" % (k, u, v, x, sp))
                                assert sp == k / 2
                                assert u == x
                            else: # odd k case
                                sys.stderr.write("odd k = %d: u = %d, v = %d, x = %d, d_Gk[(u,v)][(v,x)] = %d\n" % (k, u, v, x, sp))
                                assert sp == k // 2
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
    sys.stderr.write("usage: " + progname + "[-v] [-d] graph_edgelist.txt\n")
    sys.exit(1)


def main():
    """
    See usage message in module header block
    """
    verbose = False
    debug = False
    try:
        opts,args = getopt.getopt(sys.argv[1:], "dv")
    except:
        usage(sys.argv[0])
    for opt,arg in opts:
        if opt == '-d':
            debug = True
        elif opt == '-v':
            verbose = True
        else:
            usage(sys.argv[0])

    if len(args) != 1:
        usage(sys.argv[0])

    graph_edgelist_filename = args[0]

    g = igraph.Graph.Read(graph_edgelist_filename, format='edgelist',
                          directed=False)
    if verbose:
        sys.stderr.write(g.summary() + '\n')
    lic = longestIsometricCycle(g, verbose, debug)
    sys.stdout.write(str(lic) + "\n")
    
if __name__ == "__main__":
    main()
