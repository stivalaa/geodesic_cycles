#!/bin/sh

python ../../scripts/convertAdjacencyListToGraphML.py ../../data/patricia1993_adjlist.txt > patricia1993.graphml

cp -p ../../data/patricia1993_attributes.txt .

Rscript ../../scripts/convertGraphMLtoEdgelist.R  patricia1993.graphml > patricia1993_edgelist.txt
