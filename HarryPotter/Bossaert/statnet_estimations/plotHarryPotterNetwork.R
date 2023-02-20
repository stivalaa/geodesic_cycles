#!/usr/bin/env Rscript
###
### File:    plotHarryPotterNetwork.R
### Author:  Alex Stivala
### Created: January 2023
###
### Make visualization of Harry Potter peer support network (merged)
###
### Usage: plotHarryPotterNetwork.R
###
###
### Output is to file
###   'harrypotter_network.eps'
### WARNING: overwrites output files if they exist
###


source('load_harrypotter_data.R')


harrypotter.net <- load_harrypotter_data()
summary(harrypotter.net)
postscript('harrypotter_network.eps')
print(get.vertex.attribute(harrypotter.net, "cname"))#XXX
plot(harrypotter.net, vertex.col=1+get.vertex.attribute(harrypotter.net, "house"), label=get.vertex.attribute(harrypotter.net, "cname"), label.cex=.55, edge.col="gray")
dev.off()

