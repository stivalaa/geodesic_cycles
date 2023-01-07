#!/usr/bin/env Rscript
###
### File:    plotKapfererTailorshopNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Make visualization of Lazega law firm friendship network
###
### Usage: plotKapfererTailorshopNetwork.R
###
###
### Output is to file
###   'kapferer_tailorshop_network.eps'
### WARNING: overwrites output files if they exist
###

library(statnet)
data(kapferer)
postscript('kapferer_tailorshop_network.eps')
plot(kapferer)
dev.off()

