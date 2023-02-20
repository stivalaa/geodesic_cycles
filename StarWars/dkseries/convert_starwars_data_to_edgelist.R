#!/usr/bin/env Rscript
###
### File:    convert_starwars_data_to_edgelist.R
### Author:  Alex Stivala
### Created: January 2023
###
### Read data for Star Wars character interaction data from
###
### Evelina Gabasova. (2016). Star Wars social network (Version 1.0.1)
### [Data set]. Zenodo. http://doi.org/10.5281/zenodo.1411479
###
### Note this version Star Wars charcter interaction, all characters, 
### "merged" meaning Anakin and Darth Vader are the same node. See:
###
### http://evelinag.com/blog/2015/12-15-star-wars-social-network/
###

library(jsonlite)
library(igraph)

js <- fromJSON('../data/starwars-full-interactions-allCharacters-merged.json')
nodes_df <- js[[1]]
edges_df <- js[[2]]
nodes_df[,'id'] <- seq(0, nrow(nodes_df)-1)
g <- graph_from_data_frame(edges_df, directed=FALSE, vertices = nodes_df[,c('id','name','value','colour')])
summary(g)
g <- simplify(g)
summary(g)
write.graph(g, 'starwars_edgelist.txt', format='edgelist')

