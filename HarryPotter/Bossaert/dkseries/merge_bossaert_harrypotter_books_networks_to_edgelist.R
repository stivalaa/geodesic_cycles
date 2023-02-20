#!/usr/bin/env Rscript
###
### File:    merge_bossaert_harrypotter_books_networks_to_edgelist.R
### Author:  Alex Stivala
### Created: January 2023
##
## Read first 6 Harry Potter book networks from:
##
## Goele Bossaert and Nadine Meidert (2013). 'We are only as strong as we are united, as weak as we are divided'. A dynamic analysis of the peer support networks in the Harry Potter books. Open Journal of Applied Sciences, Vol. 3 No. 2, pp. 174-185. 
##
## Data available from the Siena website, 
## http://www.stats.ox.ac.uk/~snijders/siena/siena_datasets.htm
##
## and merge into single network, write edgelist in cwd.
## Note edgelist is zero-based for dkseries code.
##
## Note the original networks are directed 'peer support' ties, here we
## convert them to undirected. Data originally used for aa SAOM (RSiena) model
## so stored as adjacency matrices, diagonal is meaningless 
## (but must be present) so we ignore the diagonal in converting 
## to igraph objects.


library(igraph)


## Note this depends on the fact that all 6 networks are coded so they have
## the same (64) actors in the same order (id) in the adjacency matrix
## and also the same order in the names and attributes

book1 <- as.matrix(read.table("../data/hpbook1.txt"))
book2 <- as.matrix(read.table("../data/hpbook2.txt"))
book3 <- as.matrix(read.table("../data/hpbook3.txt"))
book4 <- as.matrix(read.table("../data/hpbook4.txt"))
book5 <- as.matrix(read.table("../data/hpbook5.txt"))
book6 <- as.matrix(read.table("../data/hpbook6.txt"))

hpattributes <- read.table("../data/hpattributes.txt", header=TRUE)
hpnames <- read.table('../data/hpnames.txt', header=TRUE)

colnames(book1)<-hpnames$name
rownames(book1)<-hpnames$name
colnames(book2)<-hpnames$name
rownames(book2)<-hpnames$name
colnames(book3)<-hpnames$name
rownames(book3)<-hpnames$name
colnames(book4)<-hpnames$name
rownames(book4)<-hpnames$name
colnames(book5)<-hpnames$name
rownames(book5)<-hpnames$name
colnames(book6)<-hpnames$name
rownames(book6)<-hpnames$name

g1 <- graph_from_adjacency_matrix(book1, mode="undirected", diag=FALSE)
g2 <- graph_from_adjacency_matrix(book2, mode="undirected", diag=FALSE)
g3 <- graph_from_adjacency_matrix(book3, mode="undirected", diag=FALSE)
g4 <- graph_from_adjacency_matrix(book4, mode="undirected", diag=FALSE)
g5 <- graph_from_adjacency_matrix(book5, mode="undirected", diag=FALSE)
g6 <- graph_from_adjacency_matrix(book6, mode="undirected", diag=FALSE)


gmerged <- g1 %u% g2 %u% g3 %u% g4 %u% g5 %u% g6

for (attrname in c("schoolyear", "gender", "house")) {
  gmerged <- set.vertex.attribute(gmerged, attrname, 
                                  value = hpattributes[, attrname])
}
summary(gmerged)

## This network has a lot of isolates, and it so happens that the last
## node(id 64, i.e. 0-based id 63) is an isolate, which results in the
## simple (too simple) edgelist format when it is read by other programs
## e.g. RandNetGen etc. thinking the graph has 63 nodes (instead of 64).
## (The first node id 1 i.e. 0-based id 0 is also an isolate but this does not
## matter for this problem, nor do the other isolates, only that the largest
## node id is an isolate is the issue).
## To solve this problem we permute the graph so that a non-isolate node
## (the second node,0-based id 1) is swapped with the last node.
##
## IMPORTANT: This means that this edgelist no longer lines up with the
## orignal names and attributes, so use it only for structure, not for 
## identifiying nodes or their attributes!
## For this reason we also write out the name and attributes here,
## in the new (permtued) order to match the edgelist.

permutation <- seq(1, vcount(gmerged))
stopifnot(degree(gmerged)[2] > 0)
permutation[2] <- 64
permutation[64] <- 2
gmerged <- permute(gmerged, permutation)
## Note converting to zero-based edgelist
write.table(as_edgelist(gmerged, names = FALSE)-1,
            file = "harrypotter_edgelist.txt",
            row.names = FALSE, col.names = FALSE)
hpnames <- data.frame(name = V(gmerged)$name)
hpattributes <- data.frame(schoolyear = V(gmerged)$schoolyear,
                           gender = V(gmerged)$gender,
                           house = V(gmerged)$house)
write.table(hpnames, file = 'harrypotter_names.txt', row.names = FALSE,
            col.names = TRUE)
write.table(hpattributes, file = 'harrypotter_attributes.txt',
            row.names = FALSE, col.names = TRUE)

           
