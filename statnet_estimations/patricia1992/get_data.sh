#!/bin/sh

python ../../scripts/convertAdjacencyListToGraphML.py ../../data/patricia1992_adjlist.txt > patricia1992.graphml

cp -p ../../data/patricia1992_attributes.txt .

Rscript ../../scripts/convertGraphMLtoEdgelist.R  patricia1992.graphml > patricia1992_edgelist.txt
