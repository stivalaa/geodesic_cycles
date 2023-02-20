#!/bin/sh

../../scripts/convertStanfordGraphBaseToEdgelist.py  ../data/anna.dat  > anna_edgelist.txt

../../scripts/convertStanfordGraphBaseToGraphML.py  ../data/anna.dat  > anna.graphml
