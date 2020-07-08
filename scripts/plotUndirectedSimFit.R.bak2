#!/usr/bin/Rscript
##
## File:    plotUndirectedSimFit.R
## Author:  Alex Stivala
## Created: May 2020
##
## Adapted from directed version plotEstimNetDirectedSimFit.R to work
## with undirected networks (and different input file set convention).
##
## Plot some simple graph statistics of the observed network on same
## plot as those of set of simulated networks to assess goodness-of-fit
## on some typical macro level graph statistics, similar to the
## gof procedure in statnet.
##
## Usage: Rscript plotUndirectedSimFit.R netfilename simNetFilesGlob outfile
##  netfilename      is the edgelist format observed graph.
##  simNetFilesGlob is string in shell glob format for set of simulated
##                   files e.g. "dk21/sim_modeldk21_*_edgelist.txt"
##  outfile          is output filename (PDF format).  WARNING: output
##                   file is overwritten
##
## Input network files are in simple two-column edgelist with numbered nodes
## e.g.:
## 0 2
## 0 3
## 1 4
##
## Example:
## Rscript plotEsimtNetDirectedSimFit.R ../pythonDemo/polblogs/polblogs_arclist.txt sim_polblogs
##  which will use input files sim_polblogs_0.net etc.
##
## Uses the igraph library to read Pajek format graph files and
## compute graph statistics:
##
##   Csardi G, Nepusz T: The igraph software package for complex network
##   research, InterJournal, Complex Systems
##   1695. 2006. http://igraph.org
##
## References for statnet whose gof this is based on (and in fact we use some
## of the function from):
##
##   Handcock, M. S., Hunter, D. R., Butts, C. T., Goodreau, S. M.,
##   Krivitsky, P. N., Bender-deMoll, S., and Morris,
##   M. (2016a). statnet: Software Tools for the Statistical Analysis of
##   Network Data. The Statnet Project (http://www.statnet.org). R
##   package version 2016.4.
##
##   Handcock, M. S., Hunter, D. R., Butts, C. T., Goodreau, S. M.,
##   Krivitsky, P. N., and Morris, M. (2016b). ergm: Fit, Simulate and
##   Diagnose Exponential-Family Models for Networks. The Statnet
##   Project (http://www.statnet.org). R package version 3.6.0.
##
##   Handcock, M. S., Hunter, D. R., Butts, C. T., Goodreau, S. M.,
##   Morris, and Martina (2008). statnet: Software tools for the
##   representation, visualization, analysis and simulation of network
##   data. Journal of Statistical Software, 24(1):1548.
##
##   Hunter, D. R., Handcock, M. S., Butts, C. T., Goodreau, S. M., and
##   Morris, M. (2008). ergm: A package to fit, simulate and diagnose
##   exponential-family models for networks. Journal of Statistical
##   Software, 24(3):129.
## 
## Note edge-wise and dyad-wise shared partner distribution like
## statnet GoF or something similar cannot be done with R/igraph
## (although similarity.dice in Python/igraph could be useful as it
## has the pairs not just vids parameters, R/igraph does not). See:
## https://github.com/igraph/igraph/issues/331
## So therefore using statnet library to calculate this, so have
## to load intergraph
## http://mbojan.github.io/intergraph/
## to convert to Network object and statnet,
## also too slow to be used for larger networks
## Also note only loading statnet and intergraph if required (network is
## small enough that they are practical) is if they are loaded here
## it seems another R problem means we run out of memory even on a 64 GB
## limit even though not actually used and without them it worked in less
## than 8 GB. (Really should just do everything in Python again, wasting
## far too much time & effort with R being too slow and too many problems,
## ending up having to rewrite in Python anyway like for snowball sampling...)
##

library(igraph)

library(grid)
library(gridExtra)
library(ggplot2)
library(reshape)
library(doBy)
library(scales)

## some statistics are too slow to practically compute on large networks,
## these are just guesses (and certainly for geodesic a 1.6 million node
## network could not be computed in 4 hours for example).
MAX_SIZE_GEODESIC <- 100000 ## do not do shortest paths if more nodes than this
MAX_SIZE_ESP_DSP <-  100000 ## do not do shared partners if more nodes than this


## read in R source file from directory where this script is located
##http://stackoverflow.com/questions/1815606/rscript-determine-path-of-the-executing-script
source_local <- function(fname){
  argv <- commandArgs(trailingOnly = FALSE)
  base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
  source(paste(base_dir, fname, sep=.Platform$file.sep))
}

##
## giant_component() - return largest connected component of the graph
## 
## Paramters:
##    graph - igraph to get giant componetn of
##
## Return value:
##    largest connected component of graph
##
giant.component <- function(graph) {
  cl <- clusters(graph)
  return(induced.subgraph(graph, which(cl$membership == which.max(cl$csize))))
}


##
## Return plot of degree distribution
##
## Parameters:
##    g_obs:       observed graph igraph object
##    sim_graphs:  simulated graphs list of igraph objects
##
## Return value:
##    ggplot2 object to add to plot list
##
## TODO work out how to make x axis labels better; if max degree is high
## it is just a mess, need to work out how to label every 10th or 100th
## tick mark or something.
##
deg_distr_plot <- function(g_obs, sim_graphs) {
    mode <- 'all'
    start = Sys.time()
    maxdeg <- max(sapply(sim_graphs, function(g) degree(g, mode=mode)),
                  degree(g_obs, mode='in'))
    cat("Max ", mode, " degree is ", maxdeg, "\n")
    deg_df <- data.frame(sim = rep(1:num_sim, each=(maxdeg+1)),
                           degree = rep(0:maxdeg, num_sim),
                           count = NA)
    end = Sys.time()
    cat(mode, "-degree init took ", as.numeric(difftime(end, start, unit="secs")),"s\n")
    start = Sys.time()
    for (i in 1:num_sim) {
        ## https://stackoverflow.com/questions/1617061/include-levels-of-zero-count-in-result-of-table
        deg_table <- table(factor(degree(sim_graphs[[i]], mode = mode),
                                  levels=0:maxdeg))
        deg_df[which(deg_df[,"sim"] == i), "count"] <- deg_table
    }
    deg_df$degree <- as.factor(deg_df$degree)
    deg_df$count[which(is.na(deg_df$count))] <- 0
    deg_df$nodefraction <- deg_df$count / num_nodes
    end = Sys.time()
    cat(mode, "-degree sim data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    start = Sys.time()
    obs_deg_df <- data.frame(degree = rep(0:maxdeg),
                               count = NA)
    obs_deg_table <- table(factor(degree(g_obs, mode=mode), levels=0:maxdeg))
    obs_deg_df$count <- as.numeric(obs_deg_table)
    ## without as.numeric() above get error "Error: geom_line requires
    ## the following missing aesthetics: y" when the plot is finally
    ## printed at the end. Who knows why... even though printing the
    ## data frame and the computations below are apparently not
    ## affected by this at all (does not happen with the boxplot for
    ## simulated degree distribution)
    obs_deg_df$degree <- as.factor(obs_deg_df$degree)
    obs_deg_df$count[which(is.na(obs_deg_df$count))] <- 0
    obs_deg_df$nodefraction <- obs_deg_df$count / num_nodes
    ##print(obs_deg_df)#XXX
    end = Sys.time()
    cat(mode, "-degree obs data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    start = Sys.time()
    p <- ggplot(deg_df, aes(x = degree, y = nodefraction)) + geom_boxplot()
    p <- p + geom_line(data = obs_deg_df, aes(x = degree, y = nodefraction,
                                              colour = obscolour,
                                              group = 1))
    ## the "group=1" is ncessary in the above line otherwise get error
    ## "geom_path: Each group consists of only one observation. Do you
    ## need to adjust the group aesthetic?" and it does not work.
    ## https://stackoverflow.com/questions/27082601/ggplot2-line-chart-gives-geom-path-each-group-consist-of-only-one-observation
    p <- p + ptheme
    p <- p + xlab('degree') + ylab('fraction of nodes')
    if (maxdeg > 200) {
        p <- p + scale_x_discrete(breaks = seq(0, maxdeg, by = 200))
    }
    end = Sys.time()
    cat(mode, "-degree plotting took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    return(p)
}

##
## Return histogram of degree distribution
##
## Parameters:
##    g_obs:       observed graph igraph object
##    sim_graphs:  simulated graphs list of igraph objects
##    use_log:    TRUE to do log degree
##
## Return value:
##    ggplot2 object to add to plot list
##
deg_hist_plot <- function(g_obs, sim_graphs, use_log) {
    mode <- 'all'
    start <- Sys.time()
    if (use_log) {
        dobs <- data.frame(degree = log(degree(g_obs, mode=mode)),
                           group = 'obs')
    } else {
        dobs <- data.frame(degree = degree(g_obs, mode=mode),
                           group = 'obs')
    }
    ## get degrees of all simulated graphs in one histogram
    simdegrees <- as.vector(sapply(sim_graphs, function(g) degree(g, mode=mode)))
    if (use_log) {
        dsim <- data.frame(degree = log(simdegrees), group = 'sim')
    } else {
        dsim <- data.frame(degree = simdegrees, group = 'sim')
    }
    dat <- rbind(dobs, dsim)
    end <- Sys.time()
    cat(mode, "-degree histogram data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    start <- Sys.time()
    ## https://stackoverflow.com/questions/29287614/r-normalize-then-plot-two-histograms-together-in-r
    p <- ggplot(dat, aes(degree, fill = group, colour = group)) +
        geom_histogram(aes(y = ..density..),
                       alpha = 0.4, position = 'identity', lwd = 0.2)
    p <- p + xlab(paste(ifelse(use_log, "log ", ""), 'degree', sep=''))
    p <- p + theme(legend.title=element_blank(),
                   legend.position = c(0.9, 0.8))
    end <- Sys.time()
    cat(mode, "-degree histogram plotting took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    return(p)
}


###
### Main
###

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 3) {
  cat("Usage: Rscript plotUndirectedSimFit.R netfilename simNetFilsGlob outfile\n")
  quit(save="no")
}
netfilename <- args[1]
graph_glob  <- args[2]
outfilename <- args[3]

obscolour <- 'red' # colour to plot observed graph points/lines
## simulated graph statistics will be boxplot on same plot in default colour

g_obs <- as.undirected(read.graph(netfilename, format='edgelist'))
num_nodes <- vcount(g_obs)
sim_files <- Sys.glob(graph_glob)
cat('Reading ', length(sim_files), ' graphs...\n')
system.time(sim_graphs <- sapply(sim_files,
                                 FUN = function(f)
                                   as.undirected(read.graph(f,
                                                            format='edgelist',
                                                            n = num_nodes)),
                                 simplify = FALSE))

## all simulated graphs must have the same number of nodes
stopifnot(length(unique((sapply(sim_graphs, function(g) vcount(g))))) == 1)
## and it must be the same a the number of nodes in the observed graph
stopifnot(num_nodes == vcount(sim_graphs[[1]]))
num_sim <- length(sim_graphs)

ptheme <-  theme(legend.position = 'none')


plotlist <- list()

###
### Degree
###

system.time(plotlist <- c(plotlist,
                          list(deg_distr_plot(g_obs, sim_graphs))))

system.time(plotlist <- c(plotlist,
                          list(deg_hist_plot(g_obs, sim_graphs, FALSE))))

system.time(plotlist <- c(plotlist,
                          list(deg_hist_plot(g_obs, sim_graphs, TRUE))))



###
### giant component size
###

system.time(giant_component_sizes <- sapply(sim_graphs,
                                           function(g) vcount(giant.component(g))))
giant_component_sizes <- giant_component_sizes / num_nodes
obs_gcsize <- vcount(giant.component(g_obs)) / num_nodes
cat('obs giant component size: ', obs_gcsize, '\n')
cat('sim giant component size: ', giant_component_sizes, '\n')
p <- ggplot() + geom_boxplot(aes(x = 'giant component', y = giant_component_sizes))
p <- p + geom_point(aes(x = as.numeric(ordered('giant component')),
                        y = obs_gcsize,
                        colour = obscolour))
p <- p + ylab('fraction of nodes')
p <- p + ptheme +   theme(axis.title.x = element_blank())
p <- p + ylim(0, 1)
plotlist <- c(plotlist, list(p))




###
### Transitivity (global clustering coefficient and avg. local clustering coef.)
###

cctypes <- c('average local', 'global') # must be in alphabetical order!
system.time(ccs <- sapply(sim_graphs, function(g) transitivity(g, type="global")))
system.time(cc_obs <- transitivity(g_obs, type='global'))
cat('obs global cc: ', cc_obs, '\n')
cat('sim global cc: ', ccs, '\n')
system.time(ccs_localavg <- sapply(sim_graphs, function(g)
    transitivity(g, type='localaverage')))
system.time(cc_localavg_obs <- transitivity(g_obs, type='localaverage'))
cat('obs avg local cc: ', cc_localavg_obs, '\n')
cat('sim avg local cc: ', ccs_localavg, '\n')
p <- ggplot() + geom_boxplot(aes(x = factor('global', levels=cctypes), y = ccs))
p <- p + geom_point(aes(x = as.numeric(factor('global', levels=cctypes)),
                        y = cc_obs,
                        colour = obscolour))
p <- p + geom_boxplot(aes(x = factor('average local', levels=cctypes),
                          y = ccs_localavg))
p <- p + geom_point(aes(x = as.numeric(factor('average local', levels=cctypes)),
                        y = cc_localavg_obs,
                        colour = obscolour))
p <- p + ylab('clustering coefficient') + ptheme +
  theme(axis.title.x = element_blank())
p <- p + ylim(0, 1)
plotlist <- c(plotlist, list(p))


###
### Triad census
###

## Use the sna package triad.census as it handles undirected and igraph does not
library(sna)   
library(intergraph)
system.time(net_obs <- asNetwork(g_obs))
system.time(sim_networks <- lapply(sim_graphs, function(g) asNetwork(g)))

nTriads <- choose(num_nodes, 3)
print(net_obs)#XXX
system.time(obs_triadcensus <- sna::triad.census(net_obs, mode='graph'))
print(obs_triadcensus)#XXX
num_triad_types <- length(obs_triadcensus)
stopifnot(num_triad_types == 4)
triadnames <- c('0','1','2','3') # empty, edge, two-star, triangle
stopifnot(length(triadnames) == num_triad_types)
names(obs_triadcensus) <- triadnames
cat('obs triad census: ', obs_triadcensus, '\n')
sim_triadcensus_df <- data.frame(sim = rep(1:num_sim, each = num_triad_types),
                                 triad = rep(triadnames, num_sim),
                                 count = NA)
obs_triadcensus_df <- data.frame(triad = triadnames,
                                 count = NA)
## as for degree distributions, using loops as trying to do it "properly"
## in R was just too difficult
for (tname in triadnames) {
    obs_triadcensus_df[which(obs_triadcensus_df[,"triad"] == tname,
                             arr.ind=TRUE), "count"] <-
        obs_triadcensus[tname]
}
obs_triadcensus_df$triadfraction <- obs_triadcensus_df$count / nTriads
for (i in 1:num_sim) {
    system.time(sim_triadcensus <- sna::triad.census(sim_networks[[i]],
                                                     mode='graph'))
    names(sim_triadcensus) <- triadnames
    cat('sim triad census ', i, ': ', sim_triadcensus, '\n')
    if (sim_triadcensus[1] < 0 || sim_triadcensus[2] < 0 || sim_triadcensus[3] < 0) {
        dropFirstThree <- TRUE
    }
    for (tname in triadnames) {
        sim_triadcensus_df[which(sim_triadcensus_df[,"sim"] == i &
                                 sim_triadcensus_df[,"triad"] == tname,
                                 arr.ind=TRUE), "count"] <-
            sim_triadcensus[tname]
    }
}

## make factor with triad names explicitly specified to keep them in order
sim_triadcensus_df$triad <- factor(sim_triadcensus_df$triad, levels = triadnames)
obs_triadcensus_df$triad <- factor(obs_triadcensus_df$triad, levels = triadnames)

sim_triadcensus_df$triadfraction <- sim_triadcensus_df$count / nTriads
p <- ggplot(sim_triadcensus_df, aes(x = triad, y = triadfraction))
p <- p + geom_boxplot()
p <- p + ylab('fraction of triads') + ptheme + xlab('Triad census')
p <- p + geom_line(data = obs_triadcensus_df, aes(x = triad, y = triadfraction,
                                                  colour = obscolour,
                                                  group = 1))
plotlist <- c(plotlist, list(p))  # no logarithm
## p <- p + scale_y_log10() + ylab("frac. triads (log)")
## plotlist <- c(plotlist, list(p))  # log scale on y axis




##
## geodesics (shortest paths)
##
if (num_nodes > MAX_SIZE_GEODESIC) {
    cat("WARNING: graph with ", num_nodes,
        " too large to do geodesic fit, skipping\n")
} else {
    num_dyads <- choose(num_nodes, 2) # num_nodes*(num_nodes-1)/2
    system.time(obs_geodesics <- distance_table(g_obs)$res)
    system.time(sim_geodesics <- sapply(sim_graphs,
                                        function(g) distance_table(g)$res,
                                        simplify = FALSE))
    maxgeodesic <- max(length(obs_geodesics),
                       sapply(sim_geodesics, function(v) length(v)))
    cat("Max geodesic distance is ", maxgeodesic, "\n")
    geodesic_df <- data.frame(sim = rep(1:num_sim, each = maxgeodesic),
                              geodesic = rep(1:maxgeodesic, num_sim),
                              count = NA)
    start = Sys.time()
    for (i in 1:num_sim) {
      ## pad the sim vector to max length if it is not the longest already
      sg <- sim_geodesics[[i]]
      print(sg)#XXX
      print(length(sg))#XXX
      if (length(sg) < maxgeodesic) {
        oldlen <- length(sg)
        cat('oldlen = ', oldlen, '\n')#XXX
        sg <- rep(sg, length.out = maxgeodesic)
        sg[(oldlen+1):maxgeodesic] <- 0 # pad with zeroes
      }
      geodesic_df[which(geodesic_df[,"sim"] == i), "count"] <- sg
    }
    geodesic_df$geodesic <- as.factor(geodesic_df$geodesic)
    geodesic_df$nodefraction <- geodesic_df$count / num_dyads
    end = Sys.time()
    cat("Geodesic sim data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    start = Sys.time()
    ## pad the observed vector to max length if it is not the longest already
    if (length(obs_geodesics) < maxgeodesic) {
        oldlen <- length(obs_geodesics)
        obs_geodesics <- rep(obs_geodesics, length.out = maxgeodesic)
        obs_geodesics[(oldlen+1):maxgeodesic] <- 0 # pad with zeroes
    }
    obs_geodesic_df <- data.frame(geodesic = 1:maxgeodesic,
                                  count = as.numeric(obs_geodesics))
    obs_geodesic_df$nodefraction <- obs_geodesic_df$count / num_dyads
    end = Sys.time()
    cat("Geodesic obs data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    p <- ggplot(geodesic_df, aes(x = geodesic, y = nodefraction)) + geom_boxplot()
    p <- p + geom_line(data = obs_geodesic_df, aes(x = geodesic, y = nodefraction,
                                                   colour = obscolour, group = 1))
    p <- p + ptheme +
        xlab("geodesic distance") + ylab("fraction of dyads")
    plotlist <- c(plotlist, list(p))
}



###
### edgewise shared partners
###

if (num_nodes > MAX_SIZE_ESP_DSP) {
    cat("WARNING: graph with ", num_nodes,
        "nodes too large to do edgewise shared partners, skipping\n")
} else {
    ## for some reason need to do these library and conversion again
    ## even though they are now done above before triad census; otherwise
    ## it does not work
    library(statnet)   
    library(intergraph)
    
    system.time(net_obs <- asNetwork(g_obs))
    system.time(sim_networks <- lapply(sim_graphs, function(g) asNetwork(g)))

    cutoff <- 50 # gw.cutoff default used in statnet is 30
    esp_df <- data.frame(sim = rep(1:num_sim, each = cutoff+1),
                         esp = rep(0:cutoff, num_sim),
                         count = NA)
    system.time(obs_esp <- summary(net_obs ~ esp(0:cutoff)))
    start <- Sys.time()
    for (i in 1:num_sim) {
        esp_df[which(esp_df[, "sim"] == i), "count"] <-  summary(sim_networks[[i]] ~ esp(0:cutoff))
        esp_df$edgefraction <- esp_df$count / network.edgecount(sim_networks[[i]])
    }
    end <- Sys.time()
    cat("esp sim data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    obs_esp_df <- data.frame(esp = rep(0:cutoff),
                             count = summary(net_obs ~ esp(0:cutoff)))
    obs_esp_df$edgefraction <- obs_esp_df$count / network.edgecount(net_obs)
    end <- Sys.time()
    cat("esp obs data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    ## remove zero counts from the end (use only up to max nonzero count)
    maxesp_sim <- max(esp_df[which(esp_df$count > 0),]$esp)
    maxesp_obs <- max(obs_esp_df[which(obs_esp_df$count > 0),]$esp)
    cat("Max obs esp is ", maxesp_obs, " and max sim esp is ", maxesp_sim, "\n")
    maxesp <- max(maxesp_sim, maxesp_obs)
    esp_df <- esp_df[which(esp_df$esp <= maxesp),]
    print("just before obs_esp_df subset") ## XXX trying to find line with error in R (why can't it just print line numbers like every other language?)
    obs_esp_df <- obs_esp_df[which(obs_esp_df$esp <= maxesp),]
    print("after obs_esp_df subset") ## XXX trying to find line with error in R (why can't it just print line numbers like every other language?)    
    obs_esp_df$esp <- as.factor(obs_esp_df$esp)
    print("just before factor(esp_df$esp)") ## XXX trying to find line with error in R (why can't it just print line numbers like every other language?)
    esp_df$esp <- as.factor(esp_df$esp)
    p <- ggplot(esp_df, aes(x = esp, y = edgefraction)) + geom_boxplot()
    p <- p + geom_line(data = obs_esp_df, aes(x = esp, y = edgefraction,
                                              colour = obscolour, group = 1))
    p <- p + ptheme + xlab("edgewise shared partners") +
        ylab("fraction of edges")
    plotlist <- c(plotlist, list(p))
}


###
### dyadwise shared partners
###

if (num_nodes > MAX_SIZE_ESP_DSP) {
    cat("WARNING: graph with ", num_nodes,
        "nodes too large to do dyadwise shared partners, skipping\n")
} else {
    system.time(net_obs <- asNetwork(g_obs))
    system.time(sim_networks <- lapply(sim_graphs, function(g) asNetwork(g)))

    cutoff <- 50 # gw.cutoff default used in statnet is 30
    dsp_df <- data.frame(sim = rep(1:num_sim, each = cutoff+1),
                         dsp = rep(0:cutoff, num_sim),
                         count = NA)
    system.time(obs_dsp <- summary(net_obs ~ dsp(0:cutoff)))
    start <- Sys.time()
    for (i in 1:num_sim) {
        dsp_df[which(dsp_df[, "sim"] == i), "count"] <-  summary(sim_networks[[i]] ~ dsp(0:cutoff))
        dsp_df$dyadfraction <- dsp_df$count / network.dyadcount(sim_networks[[i]])
    }
    end <- Sys.time()
    cat("dsp sim data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    obs_dsp_df <- data.frame(dsp = rep(0:cutoff),
                             count = summary(net_obs ~ dsp(0:cutoff)))
    obs_dsp_df$dyadfraction <- obs_dsp_df$count / network.dyadcount(net_obs)
    end <- Sys.time()
    cat("dsp obs data frame construction took",
        as.numeric(difftime(end, start, unit="secs")), "s\n")
    ## remove zero counts from the end (use only up to max nonzero count)
    maxdsp_sim <- max(dsp_df[which(dsp_df$count > 0),]$dsp)
    maxdsp_obs <- max(obs_dsp_df[which(obs_dsp_df$count > 0),]$dsp)
    cat("Max obs dsp is ", maxdsp_obs, " and max sim dsp is ", maxdsp_sim, "\n")
    maxdsp <- max(maxdsp_sim, maxdsp_obs)
    dsp_df <- dsp_df[which(dsp_df$dsp <= maxdsp),]
    obs_dsp_df <- obs_dsp_df[which(obs_dsp_df$dsp <= maxdsp),]
    obs_dsp_df$dsp <- as.factor(obs_dsp_df$dsp)
    dsp_df$dsp <- as.factor(dsp_df$dsp)
    p <- ggplot(dsp_df, aes(x = dsp, y = dyadfraction)) + geom_boxplot()
    p <- p + geom_line(data = obs_dsp_df, aes(x = dsp, y = dyadfraction,
                                              colour = obscolour, group = 1))
    p <- p + ptheme + xlab("dyadwise shared partners") +
        ylab("fraction of dyads")
    plotlist <- c(plotlist, list(p))
}


###
### Write the plot to PDF
###
cat("writing plots to PDF file ", outfilename, "\n")
pdf(outfilename, onefile=FALSE, paper="special", width=9, height=6)
system.time(do.call(grid.arrange, plotlist))
dev.off()
