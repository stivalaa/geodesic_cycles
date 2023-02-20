#!/usr/bin/Rscript
###
### File:    get_zachary_karateclub_edgelist.txt
### Author:  Alex Stivala
### Created: August 2019
###

library(statnet)
data(zach)
g <- zach
# convert to zero-based by subtracting 1 from node idents
write.table(as.edgelist(g)-1, file='zachary_karateclub_edgelist.txt',
            col.names = FALSE, row.names = FALSE)

