###
### File:    load_harrypotter_data
### Author:  Alex Stivala
### Created: August 2019
###
### Load the merged Harry Potter peer support network data
### https://github.com/alexleavitt/SNAinRworkshop
###

library(igraph)
library(network)
library(intergraph)


load_harrypotter_data <- function() {
  g <- read.graph('../dkseries/harrypotter_edgelist.txt', format='edgelist',
                  directed= FALSE)
  hp.atts<-read.table('../dkseries/harrypotter_attributes.txt', header=T,
                       stringsAsFactors=F)
  hp.names<-read.table('../dkseries/harrypotter_names.txt', header=T,
                       stringsAsFactors=F)
  V(g)$name <- hp.names$name
  V(g)$cname <- hp.names$name # name does not work need to use cname
  for (attrname in c("schoolyear", "gender", "house")) {
    g <- igraph::set.vertex.attribute(g, attrname, 
                              value = hp.atts[, attrname])
  }
  harrypotter.net <- asNetwork(g)
  return(harrypotter.net)
}

