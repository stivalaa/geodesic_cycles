#!/bin/sh

module load python/3.9.0

python3 ../../scripts/convertStanfordGraphBaseToEdgelist.py  ../data/anna.dat  > anna_edgelist.txt

python3 ../../scripts/convertStanfordGraphBaseToGraphML.py  ../data/anna.dat  > anna.graphml
