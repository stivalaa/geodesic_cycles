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

   Developed with python/igraph 0.9.9 under Python 3.9.10 (Cygwin
   Windows 10) and python/igraph 0.10.2 under Python 3.9.0 (Linux CentOS
   8.2.2004)


   There is an error in Lemma 3.6 in Lokshtanov (2009), which is
   preciesely the condition that leads to it, for example, showing an
   isometric cycle of length 11 in the Patricia 1990 network, when in
   fact there is no such cycle (the longest is 10).

   This error is described by:

      Catrina, F., Khan, R., Moorman, I., Ostrovskii, M., & Vidyasagar,
      L. I. C. (2021). Quantitative characteristics of cycles and their
      relations with stretch and spanning tree congestion. arXiv preprint
      arXiv:2104.07872.

   which shows a counterexample to Lokshtanov (2009) Lemma 3.6; in
   fact very similar to the Patricia 1990 case (but smaller), and
   describes how to derive a correct condition for the odd case, based
   on the even case with an auxiliary bipartite graph (see Observation
   5.4 and following proof in Catrina et al. (2021)).

   This implementation uses the auxiliary bipartite graph method of
   Catrina et al. (2021) so that it works correctly in both the even
   and odd k cases.
"""
import sys
import getopt
import igraph

def flatten(l):
    """
    flatten - flatten list of lists to a list

    https://stackoverflow.com/questions/952914/how-do-i-make-a-flat-list-out-of-a-list-of-lists
    """
    return [item for sublist in l for item in sublist]

    
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
    N = G.vcount()
    if d_G is None:
        d_G = G.shortest_paths()
    powerGk = G.copy()
    new_edges = [(u, v) for u in range(N) for v in range(N)
                 if u < v and d_G[u][v] > 1 # no loops or existing edges
                 and d_G[u][v] <= k]
    powerGk.add_edges(new_edges)
    return powerGk


def isIsometricCycleLengthkEven(G, k, d_G, verbose = False, debug = False):
    """isIsometricCycleLengthkEven - does an isometric cycle of length
                                     k (for even k) exist?

    Paramaters:
       G       - undirected connected graph object
       k       - length of isometric cycle to check for; must be even
       d_G     - precomputed shortest paths matrix from G.shortest_paths()
       verbose - Boolean, True to output progress messages to stderr
       debug   - Boolean, True to output debugging data to stderr

    Returns:
       True if isometric cycle of length exactly k exists else False

    See:
       Lokshtanov, D. (2009). Finding the longest isometric cycle in a
       graph. Discrete Applied Mathematics, 157(12), 2670-2674.

    """
    assert k % 2 == 0
    # #count = 0
    N = G.vcount()
    ## Build the auxiliary graph Gk
    Vk = [(u, v) for u in range(N) for v in range(N)
          if d_G[u][v] == k // 2] # // operator is floor division
    if debug:
        sys.stderr.write('len(Vk) = %d\n' % len(Vk))
        sys.stderr.write('Vk = %s\n' % str(Vk))
    VK = set(Vk)  # a set is basically a dict, O(1) lookup
    if debug:
        sys.stderr.write('set len(Vk) = %d\n' % len(Vk))
    ## Instead of each pair of tuples in Ek being a tuple of tuples
    ## use a frozenset of tuples, and then convert the whole list
    ## to a set to remove duplicates of the form
    ## [((a, b), (c, d)), ((c, d), (a, b))]
    ## i.e. this is the same edge in an undirected graph.
    ## Need to use frozenset for inside the list comprehension
    ## to which set is applied, as set is an unhasable type
    ## but frozenset is not.
    Ek = set([frozenset(((u, v), (w, x))) for (u, v) in Vk
              for (w, x) in Vk if
              (u, v) != (w, x) and
              G.are_connected(u, w) and G.are_connected(v, x)])
    if debug:
        sys.stderr.write('len(Ek) = %d\n' % len(Ek))
    Gk = igraph.Graph()
    # note converting tuples to strings for vertex names as only
    # integer or strings (and not tuples) can be looked up as vertex IDs
    Gk.add_vertices([str(t) for t in Vk])
    if debug:
        sys.stderr.write(str([(str(t1), str(t2)) for (t1, t2) in Ek]) + '\n')
    Gk.add_edges([(str(t1), str(t2)) for (t1, t2) in Ek])
    if debug:
        sys.stderr.write(Gk.summary() + '\n')
    assert Gk.is_simple()
    ## compute the graph power Gk^floor(k/2)
    Gkpowerk2 = graphPower(Gk, k//2)
    assert Gkpowerk2.is_simple()
    if debug:
        sys.stderr.write("Gkpowerk2.density() = %g,  Gk.density() = %g\n" % (Gkpowerk2.density(), Gk.density()))
    assert Gk.ecount() == 0 or (Gkpowerk2.density() >= Gk.density())
    for (u, v) in Vk:
        if Gkpowerk2.are_connected(str((u, v)), str((v, u))):
            # experiment to try counting not just testing for
            # existence of isometric cycles - seemed promising
            # initially, but does not work in situations where
            # multiple cycles of same length share edges, e.g. one of
            # the simplest examples showing this is the
            # fourcyccl3_bipartite_edgelist.txt example from
            # ERGMXL/example_bipartite_networks/, where the count
            # value is 8 so dividing by k (k=4) it only therefore
            # counts 2 cycles but there are 3 (in this case the same
            # error the 'atomic' method has)
            # #count += 1
            return True
    # #if verbose:
    # #    sys.stderr.write("k = %d, count = %d\n" % (k, count))
    # #return count
    return False

def longestIsometricCycleConnected(G, verbose = False, debug = False):
    """longestIsometricCycleConnected - length of longest isometric cycle in G
  
    Paramaters:
       G       - undirected connected graph object
       verbose - Boolean, True to output progress messages to stderr
       debug   - Boolean, True to output debugging data to stderr
   
    Returns:
       length of the longest isometric cycle in G

    Return the length of the longest isometric cycle, using the
    algorithm (Algorithm 4.1, "LIC - Longest Isometric Cycle" from:

      Lokshtanov, D. (2009). Finding the longest isometric cycle in a
      graph. Discrete Applied Mathematics, 157(12), 2670-2674.

    and the auxiliary bipartite graph construction to handle the case
    for odd k, from:

      Catrina, F., Khan, R., Moorman, I., Ostrovskii, M., & Vidyasagar,
      L. I. C. (2021). Quantitative characteristics of cycles and their
      relations with stretch and spanning tree congestion. arXiv preprint
      arXiv:2104.07872.

    """
    assert not G.is_directed()
    assert G.is_simple()
    assert G.is_connected()
    ans = 0
    N = G.vcount()
    d_G = G.shortest_paths()
    if G.is_tree():
        return ans
    if G.is_bipartite():
        ## bipartite graphs cannot have odd-length cycles.
        ##
        ## TODO maybe it is best not to do this check; in R/graph
        ## is_bipartite() just checks if the graph object is flagged
        ## as being bipartite (has type attribute on nodes), but in
        ## Python/igraph it seems it actually test if the graph is
        ## bipartite by finding an assignment of modes
        ## i.e. bipartite_mapping() in R/igraph.
        if verbose:
            sys.stderr.write('graph is bipartite\n')
        k_iter = range(4, N+1, 2)
        Gprime = None # only used for odd k
    else:
        k_iter = range(3, N+1) # Python zero based range for 3, 4, ..., N
        ## buld the Catrina et al. (2021) auxiliary bipartite graph Gprime
        ## which is derived from G by dividing every edge in G into two
        ## edges, with a new vertex connected to both endpoints of
        ## the original edge. (See Observation 5.4 in Catrina et al. (2021)).
        Gprime = igraph.Graph(G.vcount() + G.ecount())
        edges = flatten([[(e.source, x), (x, e.target)]
                         for (x, e) in enumerate(G.es, start = G.vcount())])
        Gprime.add_edges(edges)
        assert Gprime.ecount() == 2 * G.ecount()
        assert Gprime.is_bipartite()
        d_Gprime = Gprime.shortest_paths()
    for k in k_iter:
        if verbose:
            sys.stderr.write("k = %d\n" % k)
        if k % 2 == 0:
            ## k is even, use the Lokshtanov algorithm directly on G
            if isIsometricCycleLengthkEven(G, k, d_G, verbose, debug):
                if verbose and k != ans:
                    sys.stderr.write('ans = %d\n' % k)
                ans = k
        else:
            ## k is odd, use the Catrina et al. method with
            ## auxiliary bipartite graph Gprime;
            ## there is an isometric cycle of length k in G iff there
            ## is an isometric cycle of length 2k in Gprime.
            if isIsometricCycleLengthkEven(Gprime, k*2, d_Gprime,
                                           verbose, debug):
                if verbose and k != ans:
                    sys.stderr.write('ans = %d\n' % k)
                ans = k
    return ans


def longestIsometricCycle(G, verbose = False, debug = False):
    """longestIsometricCycle - length of the longest isometric cycle in G

    Paramaters:
       G       - undirected graph object
       verbose - Boolean, True to output progress messages to stderr
       debug   - Boolean, True to output debugging data to stderr

    Returns:
       length of the longest isometric cycle in G

    Call longestIsometricCycleConnected() on each connected component
    of G and return longest isometric cycle in the graph, which is the
    longest isometric cycle in any of the components, since a cycle
    must be entirely contained within a single component.
    """
    comps = G.decompose()
    if verbose:
        sys.stderr.write("number of components = %d\n" % len(comps))
    cyclens = [longestIsometricCycleConnected(comp, verbose, debug)
               for comp in comps]
    if verbose:
        sys.stderr.write("cyclens = " + str(cyclens) + "\n")
    return max(cyclens)

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
