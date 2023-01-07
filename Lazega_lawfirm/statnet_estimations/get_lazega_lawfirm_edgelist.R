#!/usr/bin/Rscript
###
### File:    get_lazega_lawfirm_edgelist.R
### Author:  Alex Stivala
### Created: August 2019
###


source('load_lazega_lawfirm_data.R')

g <- load_lazega_lawfirm_data()

# convert to zero-based by subtracting 1 from node idents
write.table(as.edgelist(g)-1, file='lazega_lawfirm_friendship_edgelist.txt',
            col.names = FALSE, row.names = FALSE)

