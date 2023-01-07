###
### File:    load_greysanatomy_data.R
### Author:  Alex Stivala
### Created: August 2019
###
### Load the Grey's Anatomy Hookups data and return statnet network object.
### Code taken from 
###  SNA in R Workshop
###  Administered at the University of Southern California
###  by Alex Leavitt & Joshua Clark
###  PhD students at the Annenberg School for Communication & Journalism
###   adapted from materials by Katya Ognyanova and the BadHessian blog
### https://github.com/alexleavitt/SNAinRworkshop
###

library(statnet)


load_greysanatomy_data <- function() {
  ga.el<-read.table('../data/grey_edgelist.tsv', sep="\t", header=T, quote="\"",
                    stringsAsFactors=F, strip.white=T, as.is=T)

  ga.atts<-read.table('../data/grey_nodes.tsv', sep="\t", header=T, quote="\"",
                       stringsAsFactors=F, strip.white=T, as.is=T)
  grey.net<-network(ga.el, vertex.attr=ga.atts,
                    vertex.attrnames=colnames(ga.atts), directed=F, hyper=F,
                    loops=F, multiple=F, bipartite=F)
return(grey.net)
}

