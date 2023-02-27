#!/usr/bin/Rscript
##
## File:    plotLargestCliqueSizes.R
## Author:  Alex Stivala
## Created: Feburary 2023
##
## Read observed graph and sets of simulated graphs from different models, and
## make boxplots for size of largest cliques, with horizontal line for size
## of largest clique(s) in observed network.
##
## Usage: Rscript plotLargestCliqueSizes.R
##
## Reads observed and simulated graphs from under cwd as hardcoded in script.
## Writes output to largest_clique_sizes.eps in cwd
## WARNING: overwirets if it exists.
##
## Note, as per igraph cliques documentation,
## a clique is largest if there is no other clique including more vertices,
## a clique is maximal if it cannot be extnded to a larger clque.
## The largest cliques are always maxial, but a maximal cilque is not 
## necessarily the largest.
## This script uses clique_num() to calculate the size of the largest clique(s).
## 

library(igraph)
library(ggplot2)

###
### Main
###

outputepsfilename <- 'largest_clique_sizes.eps'

obscolour <- 'red' # colour to plot observed graph points/lines
## simulated graph statistics will be boxplot on same plot in default colour

ptheme <-  theme(legend.position = 'none')


g_obs <- read.graph('../dkseries/dumbledoresarmy_edgelist.txt', format = 'edgelist', directed = FALSE)

obs_maxclique <- clique_num(g_obs)
cat('obs_maxclique = ', obs_maxclique, '\n')

ergm_files_glob <- 'simulated/model1/sim_model1_*_edgelist.txt'
print(ergm_files_glob)
sim_graphs <- sapply(Sys.glob(ergm_files_glob),
                     function(f) read.graph(f, format='edgelist', directed=FALSE))
sim_maxclique_df <- data.frame(maxclique = sapply(sim_graphs,
                                                  function(g) clique_num(g)),
                               model = "ERGM")
                                                          


for (dkfile_glob in c('../dkseries/simulated/dk0/sim_modeldk0_*_edgelist.txt',
                      '../dkseries/simulated/dk1/sim_modeldk1_*_edgelist.txt',
                      '../dkseries/simulated/dk2/sim_modeldk2_*_edgelist.txt',
                      '../dkseries/simulated/dk21/sim_modeldk21_*_edgelist.txt',
                      '../dkseries/simulated/dk25/sim_modeldk25_*_edgelist.txt')){
  print(dkfile_glob)
  dkfiles<- Sys.glob(dkfile_glob)
  sim_graphs <- sapply(dkfiles,
                     function(f) read.graph(f, format='edgelist', directed=FALSE))
  dkname <- sub("sim_model(dk[0-9]+)_.*", "\\1", basename(dkfiles[1]))
  print(dkname)
  if (dkname == "dk0") {
    dkname <- "dk 0 k"
  } else if (dkname == "dk1") {
    dkname <- "dk 1 k"
  } else if (dkname == "dk2") {
    dkname <- "dk 2 k"
  } else if (dkname == "dk21") {
    dkname <- "dk 2.1 k"
  } else if (dkname == "dk25") {
     dkname <- "dk 2.5 k"
  }
  this_sim_maxclique_df <- data.frame(maxclique = sapply(sim_graphs,
                                                   function(g) clique_num(g)),
                                      model = dkname)
  sim_maxclique_df <- rbind(sim_maxclique_df, this_sim_maxclique_df)
}

print(sim_maxclique_df)#XXX

max_maxclique <- max(obs_maxclique, sim_maxclique_df$maxclique)
cat('max_maxclique = ', max_maxclique, '\n')
p <- ggplot(sim_maxclique_df, aes(x = model, y = maxclique))
p <- p + geom_boxplot()
p <- p + ptheme
p <- p + theme(axis.text = element_text(size = 12))
p <- p + theme(axis.title = element_text(size = 12))
p <- p + theme(axis.text.x = element_text(colour = 'black'))
p <- p + ptheme + xlab('Simulation method')
p <- p + ylab('Size of largest clique')
p <- p + ylim(c(0, max_maxclique))
p <- p + geom_hline(aes(yintercept = obs_maxclique), colour = obscolour,linetype=2)

cat('Writing to ', outputepsfilename, '\n')
postscript(outputepsfilename, onefile=FALSE, paper="special", width=9, height=6)
print(p)
dev.off()


