##############################################################################
#
# readAdjacencyList.py - load data from adjacency list into igraph object
#
# File:    readAdjacencyList.py
# Author:  Alex Stivala
# Created: July 2019
#
##############################################################################

"""Function to load data in named adjacency list format and convert
to igraph object.

All networks are undirected, coded initially as adjacency lists
for ease of transcription from figures. Whitespace delimited,
one line for each node, the frist field is the name of the node,
subsequent fields on the line are nodes adjacent to that node.
Lines are in alphabetical order (by the first field i.e. the node whose
neighbours are listed) and edges are not repeated (i.e. entries are only
present from lower to higher alphabetical order; the reverse is implied as
undirected). Order (after the first field) in a line is not significant.


"""

import sys
import igraph

#-----------------------------------------------------------------------------
#
# Functions
#
#-----------------------------------------------------------------------------

def readAdjacencyList(filename):
    """
    Load adjacency list from specified file and return igraph object

    Parameters:
        filename - filename to read from

    Return value:
        igraph object for undirected graph read from filename with 
        name attribute on nodes
    """
    adjlist = [l.rstrip().split() for l in open(filename).readlines() ]
    nodelist = [l[0] for l in adjlist]
    assert(sorted(nodelist) == nodelist) # lines must be alphabetical
    g = igraph.Graph()
    g.add_vertices(nodelist)
    for l in adjlist:
        u = l[0]
        for v in l[1:]:
            if g.are_connected(u, v):
                sys.stderr.write("WARNING: ignoring duplicate edge " +
                                 u + "," + v + "\n")
                                 
            else:
                g.add_edge(u, v)

    return g
