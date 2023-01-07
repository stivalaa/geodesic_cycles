#!/usr/bin/env Rscript
###
### File:    plotPatricia1990network.R
### Author:  Alex Stivala
### Created: July 2019
###
### Draw network diagram for Patricia 1990 delusional social network.
###
### Citations for data:
###
### David, Anthony, Roisin Kemp, Ladé Smith and Thomas Fahy. 1996.  "Split
### Minds: Multiple Personality and Schizophrenia." Pp. 122-146 in Method
### in Madness: Case Studies in Neuropsychiatry, edited by Peter
### W. Halligan and John C. Marshall.
###
### Martin,J.L.(2017).The Structure of Node and Edge Generation in a
### Delusional Social Network. Journal of Social Structure, 18(1),1-21.
### cdoi:10.21307/joss-2018-005.
###  Neuroscience Abstracts 30:921.9.
###
### Usage: plotPatricia1990network.R
###
### Rrites output files to cwd:
###   'patricia1990_network_drawing_statnet.eps'
### WARNING: overwrites output files if they exist
###

library(igraph)


g = read.graph('patricia1990.graphml', format='graphml')

## do this after igraph things so as not to mess up namespaces
library(statnet)
library(intergraph)

gn <- asNetwork(g)

postscript('patricia1990_network_drawing_statnet.eps')
plot(gn, displaylabels=TRUE, label.cex=.6, vertex.col = 'white')
dev.off()


