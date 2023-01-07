#!/usr/bin/Rscript
###
### File:    get_highschoolfriendship_edgelist.R
### Author:  Alex Stivala
### Created: September 2019
###


source('load_highschoolfriendship_network.R')

g <- load_highschoolfriendship_network()

# write zero-based edgelist
write.graph(g, file = 'highschoolfriendship_edgelist.txt', 
               format = 'edgelist')
