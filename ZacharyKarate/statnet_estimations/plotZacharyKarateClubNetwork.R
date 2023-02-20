#!/usr/bin/env Rscript
###
### File:    plotZacharyKarateClubNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Make visualization of Lazega law firm friendship network
###
### Usage: plotZacharyKarateClubNetwork.R
###
###
### Output is to file
###   'zachary_karateclub_network.eps'
### WARNING: overwrites output files if they exist
###

library(statnet)
data(zach)
postscript('zachary_karateclub_network.eps')
plot(zach, vertex.col=c("green","orange","purple")[as.integer(factor(get.vertex.attribute(zach, "role")))])
dev.off()

