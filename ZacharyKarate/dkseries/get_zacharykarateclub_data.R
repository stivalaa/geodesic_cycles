#!/usr/bin/env Rscript
###
### File:    get_zacharykarateclub_data.R
### Author:  Alex Stivala
### Created: May 2020
###
### Get edgelist for Zachary karate club social network. Reference for data:
###
###  Zachary, W. W. (1977). An information flow model for conflict and
###  fission in small groups. Journal of anthropological research,
###  33(4), 452-473.
###


library(statnet)



data(zach)
gn <- zach
el <- as.edgelist(gn)-1 # convertt to 0-based not 1-based
write.table(el, 'zacharykarateclub_edgelist.txt', col.names=F, row.names=F)

