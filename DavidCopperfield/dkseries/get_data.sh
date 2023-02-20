#!/bin/sh

module load python/3.9.0

python3 ../../scripts/convertStanfordGraphBaseToEdgelist.py  ../data/david.dat  > david_edgelist.txt
python3 ../../scripts/convertStanfordGraphBaseToGraphML.py  ../data/david.dat  > david.graphml
