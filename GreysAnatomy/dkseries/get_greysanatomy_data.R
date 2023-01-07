###
### File:    get_greysanatomy_data.R
### Author:  Alex Stivala
### Created: May 2020
###
### Load the Greys Anataomyh network and convert to plain edgelist
### (no attributes) for RandNetGen
###

library(statnet)

source('../statnet_estimations/load_greysanatomy_data.R')

grey.net <- load_greysanatomy_data()

el <- as.edgelist(grey.net)-1 # convertt to 0-based not 1-based
write.table(el, 'greysanatomy_edgelist.txt', col.names=F, row.names=F)
