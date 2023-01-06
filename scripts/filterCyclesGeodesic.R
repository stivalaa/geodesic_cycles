#!/usr/bin/env Rscript
##
## File:    filterCyclesGeodesic.R
## Author:  Alex Stivala
## Created: December 2022
##
## Usage: Rscript filterCyclesGeodesic.R graph_egelist.txt
##
##
## Read graph in edgelist format (nodes must be 0..N-1) from graph_edgelist.txt
## and list of cycles as comma-delimited node identifiers (0..N-1)
## from stdin and output only those that are geodesic.
## Note the output is 1-based not 0-based (while the input is 0-based)
##
## Note the input cycles must be listed as nodes in order along cycle e.g.
##
## 0,1,4,5,2
##
## means there is a cycle 0 - 1 - 4 - 5 - 2 - 0 (note 0 appears only once
## in the actual input; and this could equally be 1,4,5,2,0 etc.)
## This is the output from CYPATH for example.
##
## Example:
##
## transgrh.pl < fourcycle3_bipartite_edgelist.txt  > fourcycle3_bipartite.grh
##
## cypath C -, , fourcycle3_bipartite.grh  - | fgrep  , | ./filterCyclesGeodesic.R  fourcycle3_bipartite_edgelist.txt 
##
## Note in the above example, capital C on cypath to get chordless cycles only,
## since a geodesic cycle must be chordless. The "-, ," option sets the
## output delimiter to comma, and fgrep used to get only lines with comma,
## so that summary (cycle length counts) information is removed (there is 
## a q option documented to do this, but appears not to be implemented).
##
## The output of this script is the same format as the input (although the
## node numbers are converted to 1-based, not 0-based as in input), 
##i so for example you can get a histogram of geodesic cycle lengths with:
##
## cypath C -, , fourcycle3_bipartite.grh  - | fgrep  , | ./filterCyclesGeodesic.R  fourcycle3_bipartite_edgelist.txt  | awk -F, '{print NF}' | sort -n | uniq -c | awk '{print $2,$1}'
##
## which uses awk, sort, and uniq to get output like this:
## 4 3
## meaning there are 3 geodesic cycles of length 4.
##
##
## For CYPATH see:
##
##    http://research.nii.ac.jp/~uno/code/cypath.html
##    http://research.nii.ac.jp/~uno/code/cypath11.zip
## 
##    Uno, T., & Satoh, H. (2014, October). An efficient algorithm for
##    enumerating chordless cycles and chordless paths. In International
##    Conference on Discovery Science (pp. 313-324). Springer, Cham.
##

suppressPackageStartupMessages(library(igraph))

## read in R source file from directory where this script is located
##http://stackoverflow.com/questions/1815606/rscript-determine-path-of-the-executing-script
source_local <- function(fname){
  argv <- commandArgs(trailingOnly = FALSE)
  base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
  source(paste(base_dir, fname, sep=.Platform$file.sep))
}
source_local('isCycleGeodesic.R')


###
### main
###
args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  cat("Usage: Rscript filterCyclesGeodesic.R graph_edgelist.txt\n")
  quit(save="no")
}
graph_edgelist_filename <- args[1]

g <- read.graph(graph_edgelist_filename, format='edgelist', directed = FALSE)

distmatrix <- distances(g)

## why is it so hard in R to just read stdin line by line?
## https://stackoverflow.com/questions/9370609/piping-stdin-to-r
f <- file("stdin")
open(f)
num_read <- 0
num_geodesic <- 0
while(length(line <- readLines(f, n = 1)) > 0) {
  cycle <- as.numeric(unlist(strsplit(line, ',')))
  cycle <- cycle + 1 # convert to 1-based from 0-based for R
  num_read <- num_read + 1
  if (isCycleGeodesic(g, distmatrix, cycle)) {
    num_geodesic <- num_geodesic + 1
    cat(paste(noquote(cycle), collapse=','), '\n')
  }
}
cat('Read ', num_read, ' cycles, of which ', num_geodesic, ' are geodesic\n',
    file = stderr())
