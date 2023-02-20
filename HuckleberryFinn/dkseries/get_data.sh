#!/bin/sh

module load python/3.9.0

python3 ../../scripts/convertStanfordGraphBaseToEdgelist.py  ../data/huck.dat  > huck_edgelist.txt
