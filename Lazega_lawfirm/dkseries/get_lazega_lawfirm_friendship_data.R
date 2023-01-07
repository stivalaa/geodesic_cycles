###
### File:    get_lazega_lawfirm_friendship_data.R
### Author:  Alex Stivala
### Created: May 2020
###
### Load the law firm friendship network and convert to plain edgelist
### (no attributes) for RandNetGen
###

source('../statnet_estimations/load_lazega_lawfirm_data.R')

gn <- load_lazega_lawfirm_data()
el <- as.edgelist(gn)-1 # convertt to 0-based not 1-based
write.table(el, 'lazega_lawfirm_friendship_edgelist.txt', col.names=F, row.names=F)

