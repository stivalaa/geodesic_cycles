#!/usr/bin/env python
##############################################################################
#
# convergAdjacencyListToGraphML.py - convert adjacency list to GraphML format
#
# File:    convergAdjacencyListToGraphML.py
# Author:  Alex Stivala
# Created: July 2019
#
##############################################################################

"""Convert adjacency list to GraphML format

Usage:
   convertAdjacencyListToGraphML.py infile 

      infile - adjacnecy list filename to open

   Output is to stdout in GraphML format.

Example:

    convertAdjacencyListToGraphML.py ../data/patricia1990_adjlist.txt

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

    g.write_graphml(sys.stdout)

if __name__ == "__main__":
    main()
