#!/bin/sh

python ../scripts/convertAdjacencyListToGraphML.py ../data/patricia1990_adjlist.txt > patricia1990.graphml

Rscript ../../scripts/convertGraphMLtoEdgelist.R  patricia1990.graphml > patricia1990_edgelist.txt

