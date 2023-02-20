#!/bin/sh

module load r
../../scripts/convertGMLtoEdgelist.R  ../data/lesmis.gml  > lesmis_edgelist.txt

