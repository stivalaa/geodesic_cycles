#!/usr/bin/Rscript
###
### File:    get_kapferer_tailorshop_edgelist.txt
### Author:  Alex Stivala
### Created: August 2019
###

library(statnet)
data(kapferer)
g <- kapferer
# convert to zero-based by subtracting 1 from node idents
write.table(as.edgelist(g)-1, file='kapferer_tailorshop_edgelist.txt',
            col.names = FALSE, row.names = FALSE)

