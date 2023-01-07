#!/usr/bin/env Rscript
###
### File:    get_kapferertailorshop_data.R
### Author:  Alex Stivala
### Created: May 2020
###
### Get data for Kapferer tailor shop
### social network. Reference for data:
###
###  Kapferer, Bruce (1972), Strategy and Transaction in an African Factory, 
###  Manchester University Press.
###

library(statnet)



data(kapferer)
gn <- kapferer
el <- as.edgelist(gn)-1 # convertt to 0-based not 1-based
write.table(el, 'kapferertailorshop_edgelist.txt', col.names=F, row.names=F)


