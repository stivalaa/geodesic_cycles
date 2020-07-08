#!/usr/bin/env Rscript
###
### File:    convertAttributesToPajek.R
### Author:  Alex Stivala
### Created: July 2019
###
### Convert attributes from the for Patricia 1993 delusional
### social network from whitespace delimited data entry format (useful
### for R read.table) to vectors and clusters for Pajek.
###
### Citations for data:
###
### David, Anthony, Roisin Kemp, Ladé Smith and Thomas Fahy. 1996.  "Split
### Minds: Multiple Personality and Schizophrenia." Pp. 122-146 in Method
### in Madness: Case Studies in Neuropsychiatry, edited by Peter
### W. Halligan and John C. Marshall.
###
### Martin,J.L.(2017).The Structure of Node and Edge Generation in a
### Delusional Social Network. Journal of Social Structure, 18(1),1-21.
### cdoi:10.21307/joss-2018-005.
###  Neuroscience Abstracts 30:921.9.
###
### Usage: convertAttributesToPajek.R <inputfile>
###
### Input data format:
###   patricia1993_attributes.txt
###               whitespace delimited attributes (with header)
###               integrated is 0/1 for shaded ("integrated alters")
###               christian is 0/1 for asterisk "Christian alters")
###               number (float) is the number (age?) on some nodes or NA
###               sphere is 0/1 for in the 'sphere of the blue flame'
###               behind is 0/1 for marked as '(Behind)' on drawing
###
### Output files:
###    <basename>_integrated.vec
###    <basename>_christian.vec
###    <basename>_number.vec
###    <basename>_sphere.clu
###    <basename>_behind.clu
###
### where <basename> is basename of input file e.g. patricia1993_attributes
###
### WARNING: overwrites output files if they exist
###

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  cat("Usage: convertAttributesToPajek.R infilename\n")
  quit(save="no")
}
infile <- args[1]

basefilename <- sub("(.+)[.].+", "\\1", basename(infile))

attr <- read.table(infile, stringsAsFactors = FALSE, header = TRUE)
numvertices <- nrow(attr)

outfile <- paste(basefilename, '_integrated.vec', sep='')
write(paste('*vertices', numvertices), file = outfile, append = FALSE)
write.table(attr$integrated, file = outfile, col.names = FALSE,
            row.names = FALSE, append = TRUE)

outfile <- paste(basefilename, '_christian.vec', sep='')
write(paste('*vertices', numvertices), file = outfile, append = FALSE)
write.table(attr$christian, file = outfile, col.names = FALSE,
            row.names = FALSE, append = TRUE)

outfile <- paste(basefilename, '_number.vec', sep='')
write(paste('*vertices', numvertices), file = outfile, append = FALSE)
write.table(attr$number, file = outfile, col.names = FALSE,
            row.names = FALSE, append = TRUE)

outfile <- paste(basefilename, '_sphere.clu', sep='')
write(paste('*vertices', numvertices), file = outfile, append = FALSE)
write.table(attr$sphere, file = outfile, col.names = FALSE,
            row.names = FALSE, append = TRUE)

outfile <- paste(basefilename, '_behind.clu', sep='')
write(paste('*vertices', numvertices), file = outfile, append = FALSE)
write.table(attr$behind, file = outfile, col.names = FALSE,
            row.names = FALSE, append = TRUE)

