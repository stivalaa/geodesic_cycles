#!/usr/bin/env python
##############################################################################
#
# Convert Stanford Graph Base format to edge list 
#
# File:    convertStanfordGraphBaseToAdjMatrix.py
# Author:  Alex Stivala
# Created: August 2019
#
##############################################################################

"""Convert Stanford Graph Base format file to edge list

Usage:
   convertStanfordGraphBaseToAdjMatrix.py infile 

      infile - filename of .sgb file to read

   Output is to stdout in adjaency matrix format

Example:

    convertStanfordGraphBaseToEdgeList.py anna.sgb

"""

import os,sys
import igraph

from readStanfordGraphBaseFile import read_stanford_graphbase

#-----------------------------------------------------------------------------
#
# Main
#
#-----------------------------------------------------------------------------

def usage(progname):
    """
    print usage msg and exit
    """
    sys.stderr.write("usage: " + progname + " sgbfilename\n")
    sys.exit(1)


def main():
    """
    See usage message in module header block
    """
    if (len(sys.argv) != 2):
        usage(sys.argv[0])

    infilename = sys.argv[1]
    
    g = read_stanford_graphbase(infilename)

    g.write_adjacency(sys.stdout)

if __name__ == "__main__":
    main()
