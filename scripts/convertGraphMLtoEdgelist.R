#!/usr/bin/Rscript
##
## File:    convertGraphMLtoEdgelist
## Author:  Alex Stivala
## Created: July 2019
##
## read GraphML file and write graph in edge list format.
##
## Usage: Rscript convertGraphMLtoEdgelist.R file.graphml 
##
##    file.graphml is GraphML file to read
##  
## Output is edgelist format (0 based sequential node numbers) to stdout
##
## Example:
##      Rscript convertGraphMLtoEdgelist.R graph90.graphml > graph9_edgelist.txt
##
##

library(igraph)

###
### Main
###

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  cat("Usage: Rscript convertGraphMLtoEdgelist.R\n")
  quit(save="no")
}
infilename <- args[1]

g <- read.graph(infilename, format='graphml')
el <- get.edgelist(g, names=FALSE) - 1 # convertt to 0-based not 1-based for CYPATH
write.table(el, col.names=F, row.names=F)

