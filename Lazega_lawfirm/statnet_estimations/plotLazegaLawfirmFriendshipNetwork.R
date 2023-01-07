#!/usr/bin/env Rscript
###
### File:    plotLazegaLawfirmFriendshipNetwork.R
### Author:  Alex Stivala
### Created: August 2019
###
### Make visualization of Lazega law firm friendship network
###
### Usage: plotLazegaLawfirmFriendshipNetwork.R
###
###
### Output is to file
###   'lazega_lawfirm_network.eps'
### WARNING: overwrites output files if they exist
###


source('load_lazega_lawfirm_data.R')


lawfirm.net <- load_lazega_lawfirm_data()
print(lawfirm.net)
postscript('lazega_lawfirm_network.eps')
plot(lawfirm.net, vertex.col=c("green","orange","purple")[get.vertex.attribute(lawfirm.net, "OFFICE")])
dev.off()

