#!/bin/sh

../../scripts/convertStanfordGraphBaseToEdgelist.py  ../data/david.dat  > david_edgelist.txt
../../scripts/convertStanfordGraphBaseToGraphML.py  ../data/david.dat  > david.graphml
