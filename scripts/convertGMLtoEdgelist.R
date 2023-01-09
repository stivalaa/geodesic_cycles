#!/usr/bin/env Rscript
##
## File:    convertGMLtoEdgelist
## Author:  Alex Stivala
## Created: January 2023
##
## read GML file and write graph in edge list format.
##
## Usage: Rscript convertGMLtoEdgelist.R file.gml 
##
##    file.gml is GML file to read
##  
## Output is edgelist format (0 based sequential node numbers) to stdout
##
## Example:
##      Rscript convertGMLtoEdgelist.R graph90.gml > graph9_edgelist.txt
##
##

library(igraph)

###
### Main
###

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  cat("Usage: Rscript convertGMLtoEdgelist.R\n")
  quit(save="no")
}
infilename <- args[1]

g <- read.graph(infilename, format='gml')
el <- get.edgelist(g, names=FALSE) - 1 # convertt to 0-based not 1-based for CYPATH
write.table(el, col.names=F, row.names=F)

