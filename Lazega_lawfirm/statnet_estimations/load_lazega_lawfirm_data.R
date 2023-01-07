###
### File:    load_lazega_lawfirm_data.R
### Author:  Alex Stivala
### Created: August 2019
###
### Load the Lazega law firm friendship data and return statnet network object.
###

library(statnet)


load_lazega_lawfirm_data <- function() {
  adjmatrix<-as.matrix(read.table('../data/friendship_adjmatrix.txt', sep=" ",
                                  header=FALSE, quote="\"", stringsAsFactors=FALSE))

  contattrs <- read.table('../data/lazega_contattr.txt',
                         sep="\t", header=TRUE, stringsAsFactors=FALSE)
  catattrs <- read.table('../data/lazega_catattr.txt',
                         sep="\t", header=TRUE, stringsAsFactors=FALSE)
  binattrs <- read.table('../data/lazega_binattr.txt',
                         sep="\t", header=TRUE, stringsAsFactors=FALSE)
  attrs <- cbind(contattrs, catattrs, binattrs)
  friendship.net<-network(adjmatrix, vertex.attr=attrs,
                    vertex.attrnames=colnames(attrs), directed=FALSE, hyper=FALSE,
                    loops=FALSE, multiple=FALSE, bipartite=FALSE)
  return(friendship.net)
}

