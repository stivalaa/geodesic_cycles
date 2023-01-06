#!/usr/bin/env python
##############################################################################
#
# convertAdjacencyListToAdjMatrix.py - convert adjacency list to matrix format
#
# File:    convergAdjacencyListToAdjMatrix.py
# Author:  Alex Stivala
# Created: July 2019
#
##############################################################################

"""Convert adjacency list to AdjMatrix format

Usage:
   convertAdjacencyListToAdjMatrix.py infile 

      infile - adjacnecy list filename to open

   Output is to stdout in adjacency matrix format.

Example:

    convertAdjacencyListToAdjMatrix.py ../data/patricia1990_adjlist.txt

"""

import os,sys
import igraph

from readAdjacencyList import readAdjacencyList

#-----------------------------------------------------------------------------
#
# Main
#
#-----------------------------------------------------------------------------

def usage(progname):
    """
    print usage msg and exit
    """
    sys.stderr.write("usage: " + progname + " adjlistfilename\n")
    sys.exit(1)


def main():
    """
    See usage message in module header block
    """
    if (len(sys.argv) != 2):
        usage(sys.argv[0])

    infilename = sys.argv[1]
    
    g = readAdjacencyList(infilename)

    g.write_adjacency(sys.stdout)

if __name__ == "__main__":
    main()
