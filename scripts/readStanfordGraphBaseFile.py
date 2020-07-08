##############################################################################
#
# readStanfordGraphBase.py - load data from Stanford Graph Base format file
#
# File:    readStanfordGraphBase.py
# Author:  Alex Stivala
# Created: August 2019
#
##############################################################################

"""Function to load data in Stanford Graph Base format and convert
to igraph object.

Code adapted from Books.read() in books.py from charnet project:

https://ajholanda.github.io/charnet/

but converted here to work with igraph as the original required python 3
and graph-tool which I cannot get to install, easier to just cut & paste code.

The reference for charnet is:

A. J. Holanda et al. "Character Networks and Book Genre
Classification." Preprint, arXiv:1704.08197 (2017)
[https://arxiv.org/abs/1704.08197v2 (2018) latest version]

and for the Stanford Graph Base is:

Donald Knuth, The Stanford Graph Base: A Platform for Combinatorial
Computing, ACM Press, 1993, ISBN: 0201542757, LC: QA164.K6.

File format desciption from https://ajholanda.github.io/charnet/ :


The format follows the SGB graph data representation for books, for
example the content

* File "example.dat"
* Comments
AA character A from country A
AB character A from city B
BC character B married with CC
CB character C married with BC
1:AA,BC;AA,AB,BC
2:AA,BC,CB
* End of file "example.dat"

represents the file example.dat that contains four nodes { AA , AB ,
BC , CC }. After the node label, there is a space and then the node
description. The edges list starts after a empty line, the number at
the starting of line represents the chapter or verse, and after the
comma starts the list of encounters separated by semicolon. For
example, in the chapter or verse 1, AA meets BC and after some period
of time AA , AB and BC meet themselves.  The asterisk symbol is used
to start comments.

"""

import sys
import igraph

def read_stanford_graphbase(sgbfilename):
    """
    Read the file containing characters encounters of a book in 
    Stanford Graph Base format and return a graph.

    Code adapted from Books.read() in books.py from charnet project:
    https://ajholanda.github.io/charnet/

    Paramters: 
       sgbfilename - filename of Stanford GraphBase file to read
    Return value
       igraph object
    """
    graph = igraph.Graph()
    are_edges = False
    file_name = sgbfilename
    _file = open(file_name, "r")
    u_vert = 'AA' # store old vertex label and it is used to check it the order is right
    for line in _file:
        # ignore comments
        if line.startswith("*"):
            continue
        # edges start after an empty line
        if line.startswith('\n') or line.startswith('\r'):
            are_edges = True
            continue
        # remove new line
        line = line.rstrip('\r\n')
        # boolean are_edges indicates if it is inside vertices region
        if are_edges is False:
            (v_vert, character_name) = line.split(' ', 1)
            # check the order
            if u_vert > v_vert:
                LOGGER.error('* Labels %s and %s is \
                             out of order',
                             u_vert, v_vert)
                exit()

            #if not self.exists(v_vert):
            if len(graph.vs) == 0 or len(graph.vs.select(name_eq = v_vert)) == 0:
                #self.add_char(v_vert, character_name)
                graph.add_vertex(v_vert, char_name = character_name,
                                 frequency = 0)
                u_vert = v_vert
            else:
                LOGGER.error('* Label %s is repeated.', v_vert)
                exit()
            continue
        # edges region from here
        # eg., split "1.2:ST,MR;ST,PH,MA;MA,DO" => ["1.2" , "ST,MR;ST,PH,MA;MA,DO"]
        (_, edges_list) = line.split(':', 1)
        # eg., split "ST,MR;ST,PH,MA;MA,DO" => ["ST,MR", "ST,PH,MA", "MA,DO"]
        edges = edges_list.split(';')
        if edges[0] == '': # eliminate chapters with no edges
            continue
        for edge in edges:
            # eg., split "ST,PH,MA" => ["ST", "PH", "MA"]
            verts = edge.split(',')  # vertices
            # add vertices to graph G if it does not exit
            # otherwise, increment frequency
            for v_vert in verts:
                if (len(graph.vs.select(name_eq = v_vert)) == 0):
                    LOGGER.error('* Label \"%s\" was not added \
                                 as node in the graph.',
                                 v_vert)
                    exit()
                else:
                    #self.inc_freq(v_vert)
                    graph.vs.find(name = v_vert)['frequency'] += 1
                    ###print v_vert #XXX
            # add characters encounters (edges) to graph G
            for i in range(len(verts)):
                u_vert = verts[i]
                for j in range(i+1, len(verts)):
                    v_vert = verts[j]
                    # link u--v
                    #if not self.met(u_vert, v_vert):
                    #    self.add_encounter(u_vert, v_vert)
                    if not graph.are_connected(u_vert, v_vert):
                        graph.add_edge(u_vert, v_vert, weight = 1)
                        ###print 'added ',u_vert,'--',v_vert #XXX
                    else: # u--v already in G, increase weight
                        #self.inc_weight(u_vert, v_vert)
                        assert(graph.are_connected(u_vert, v_vert))
                        ###print(graph)#XXX
                        ###print 'find', u_vert, v_vert #XXX
                        u_index = graph.vs.find(name=u_vert).index
                        v_index = graph.vs.find(name=v_vert).index
                        ###print 'find edge between',u_index,v_index #XXX
                        #https://stackoverflow.com/questions/31643907/igraph-unexpected-behavior-in-select-edge-based-on-source-target-in-an-undirect
                        # the following does not work, even though
                        # undirected, get no edge if v_index < u_index
                        #edge = graph.es.find(_source = u_index, _target = v_index)
                        # so do this instead:
                        edge_index = graph.get_eid(u_index, v_index)
                        edge = graph.es[edge_index]
                        edge['weight'] += 1
                        
    _file.close()

    return graph
