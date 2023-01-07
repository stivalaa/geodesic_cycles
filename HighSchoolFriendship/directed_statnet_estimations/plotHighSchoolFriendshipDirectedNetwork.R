#!/usr/bin/env Rscript
###
### File:    plotHighSchoolFriendshipDirectedNetwork.R
### Author:  Alex Stivala
### Created: September 2019
###
### Make visualization of high schol friendship network
###
###
### Output is to file
###   'highschoolfriendship_directed_network.eps'
### WARNING: overwrites output files if they exist
###


source('load_highschoolfriendship_directed_network.R')


g <- load_highschoolfriendship_directed_network()

library(intergraph)
library(statnet)
gn <-asNetwork(g)
summary(gn)
postscript('highschoolfriendship_directed_network.eps')
plot(gn, vertex.col = ifelse(get.vertex.attribute(gn, "sex")=="F", "pink",
                        ifelse(get.vertex.attribute(gn, "sex")=="M", "blue",
                          "gray")),
      displaylabels=FALSE)

dev.off()

