#!/usr/bin/env python3
##############################################################################
#
# File:    filterCycleGeodesic.py 
# Author:  Alex Stivala
# Created: December 2022
#
##############################################################################
"""
   Usage: filterCyclesGeodesic.R graph_egelist.txt
  
  
   Read graph in edgelist format (nodes must be 0..N-1) from graph_edgelist.txt
   and list of cycles as comma-delimited node identifiers (0..N-1)
   from stdin and output only those that are geodesic.
   Note the output is 1-based not 0-based (while the input is 0-based)
  
   Note the input cycles must be listed as nodes in order along cycle e.g.
  
   0,1,4,5,2
  
   means there is a cycle 0 - 1 - 4 - 5 - 2 - 0 (note 0 appears only once
   in the actual input; and this could equally be 1,4,5,2,0 etc.)
   This is the output from CYPATH for example.
  
   Example:
  
   transgrh.pl < fourcycle3_bipartite_edgelist.txt  > fourcycle3_bipartite.grh
  
   cypath C -, , fourcycle3_bipartite.grh  - | fgrep  , | ./filterCyclesGeodesic.R  fourcycle3_bipartite_edgelist.txt 
  
   Note in the above example, capital C on cypath to get chordless cycles only,
   since a geodesic cycle must be chordless. The "-, ," option sets the
   output delimiter to comma, and fgrep used to get only lines with comma,
   so that summary (cycle length counts) information is removed (there is 
   a q option documented to do this, but appears not to be implemented).
  
   The output of this script is the same format as the input (although the
   node numbers are converted to 1-based, not 0-based as in input), 
  i so for example you can get a histogram of geodesic cycle lengths with:
  
   cypath C -, , fourcycle3_bipartite.grh  - | fgrep  , | ./filterCyclesGeodesic.R  fourcycle3_bipartite_edgelist.txt  | awk -F, '{print NF}' | sort -n | uniq -c | awk '{print $2,$1}'
  
   which uses awk, sort, and uniq to get output like this:
   4 3
   meaning there are 3 geodesic cycles of length 4.

  This is a direct rewrite of R script fileterCyclesGeodesic.R in Python,
  and even using exactly the same algorithm and igraph library, it is
  several times faster than R version even on small examples.
  
   For CYPATH see:
  
      http://research.nii.ac.jp/~uno/code/cypath.html
      http://research.nii.ac.jp/~uno/code/cypath11.zip
   
      Uno, T., & Satoh, H. (2014, October). An efficient algorithm for
      enumerating chordless cycles and chordless paths. In International
      Conference on Discovery Science (pp. 313-324). Springer, Cham.
  
"""
import sys
import itertools
import functools

import igraph


g = None #global variable for graph g otherwise cannot memoized geodesic

@functools.cache # Memoize the twoPaths function (Python 3.9)
def geodesic(u):
    """
    geodesic - return shortest path distance between u and v in g

    Parameters:
       u           - node in g

    Globals:
       g           - undirected graph object
    
    Returns:
       geodesic (shortest path) distances from u in g

    The point of having a function to do this is to avoid pre-computing
    the entire all-pairs shortest paths matrix, and use memoization
    on this function instead.

    Note graph g is a global otherwise cannot memoize (unhashable type Graph)
    """
    global g
    return g.shortest_paths(u)[0]


def isCycleGeodesic(cycle):
    """
    isCycleGeodesic - test if a cycle in a graph g is a geodesic cycle
  
    Paramters:
       cycle       - nodes in a cycle specified as a vector of nodes in g,
                     IN ORDER along cycle, so that distance 
                     in cycle is just cycle difference of their indices

    Globals:
       g           - undirected graph object
   
    Returns:
       TRUE if the cycle is geodesic else FALSE
  
    A geodesic cycle is a cycle such that the distance along the cycle
    between any pair of nodes in the cycle is the same as their distance 
    in the graph.
  
    This function tests if the cycle is geodesic simply using the definition.
    Note it does NOT test if the input cycle is actually a cycle, this is a
    precondition.

    Note graph g is a global otherwise cannot memoize (unhashable type Graph)
  
    """
    global g
    # geodesic distance of each pair of nodes in cycle
    nodepairs = list(itertools.combinations(cycle, 2))

    graph_dists = [geodesic(u)[v] for (u, v) in nodepairs]

    # get indices in cycle vector of nodes in nodepairs
    nodepair_indices = [(cycle.index(u), cycle.index(v))
                        for (u, v) in nodepairs]

    # and now get distance along cycle of each pair of nodes in cycle,
    # which is just cycle difference min(abs(i-j), k - abs(i-j))
    # of their indices i,j, where k is cycle length
    k = len(cycle)
    cycle_dists = [min(abs(i-j), k - abs(i-j)) for (i,j) in nodepair_indices]

    return cycle_dists == graph_dists

   

#-----------------------------------------------------------------------------
#
# main
#
#-----------------------------------------------------------------------------

def usage(progname):
    """
    print usage msg and exit
    """
    sys.stderr.write("usage: " + progname + "graph_edgelist.txt\n")
    sys.exit(1)


def main():
    """
    See usage message in module header block
    """
    global g
    
    if (len(sys.argv) != 2):
        usage(sys.argv[0])

    graph_edgelist_filename = sys.argv[1]

    # Note Graph g is a global so can memoize functions
    g = igraph.Graph.Read(graph_edgelist_filename, format='edgelist',
                          directed=False)
    
    num_read = 0
    num_geodesic = 0
    for line in sys.stdin:
        cycle = [int(s) for s in line.split(',')]
        num_read += 1
        if isCycleGeodesic(cycle):
            num_geodesic += 1
            # note output converted to 1-based to match R output
            sys.stdout.write(','.join([str(i+1) for i in cycle]) + '\n')

    sys.stderr.write('Read %u cycles, of which %u are geodesic\n'
                     % (num_read, num_geodesic))

    sys.stderr.write("geodesic cache info: " +  str(geodesic.cache_info()))

if __name__ == "__main__":
    main()
