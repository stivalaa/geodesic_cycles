#!/usr/bin/env Rscript
###
### File:    convert_everton_harrypotter_data_to_edgelist.R
### Author:  Alex Stivala
### Created: January 2023
#
#Read data for Harry Potter "Dumbledore's Army" network from
#
# Everton, S., Everton, T., Green, A., Hamblin, C., & Schroeder, R. (2022). Strong ties and where to find them: or, why Neville and Bellatrix might be more important than Harry and Tom. Social Network Analysis and Mining, 12(1), 1-18.
#
#Downloaded from
#
#https://core-dna.netlify.app/publication/harry_potter_dumbledores_army/
#
#on 13 January, 2023. Using "CSV" button on Nodes and Edges tables seemed to just hang forever,
#had to use "Copy" button instead and pasted into nodes.txt and edges.txt files, deleting "datatabes"
#and blank line at top, leaving colum titles as first row. Apperas to be tab-delimited.
#
# and convert to edgelist.
#For more infomartion see https://core-dna.netlify.app/publication/harry_potter_dumbledores_army/
#

library(igraph)

min_tie_strength <- 4 # use tie strength as in Table 4 in Everton et al (2022)
nodes_df <- read.delim('../data/nodes.txt')
edges_df <- read.delim('../data/edges.txt')
g <- graph_from_edgelist(as.matrix(edges_df[,c('source','target')]), directed=FALSE)
E(g)$weight <- edges_df$weight
summary(g)
g <- delete.edges(g, E(g)[weight < 4])
g <- remove.edge.attribute(g, 'weight')
summary(g)
write.graph(g, 'dumbledoresarmy_edgelist.txt', format='edgelist')

