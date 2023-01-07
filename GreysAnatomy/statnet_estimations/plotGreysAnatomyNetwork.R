#!/usr/bin/env Rscript
###
### File:    plotGreysAnatomyNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Make visualization of Greys Anatomy 'hookups' social network.
###
### code adapted from 
###  SNA in R Workshop
###  Administered at the University of Southern California
###  by Alex Leavitt & Joshua Clark
###  PhD students at the Annenberg School for Communication & Journalism
###   adapted from materials by Katya Ognyanova and the BadHessian blog
### https://github.com/alexleavitt/SNAinRworkshop
### https://badhessian.org/2012/09/lessons-on-exponential-random-graph-modeling-from-greys-anatomy-hook-ups/
###
### Usage: plotGreysAnatomyNetwork.R
###
###
### Output is to file
###   'greysanatomy_network.eps'
### WARNING: overwrites output files if they exist
###


source('load_greysanatomy_data.R')


grey.net <- load_greysanatomy_data()
summary(grey.net)
postscript('greysanatomy_network.eps')
plot(grey.net, vertex.col=c("blue","pink")[1+(get.vertex.attribute(grey.net, "sex")=="F")], label=get.vertex.attribute(grey.net, "name"), label.cex=.75)
dev.off()

