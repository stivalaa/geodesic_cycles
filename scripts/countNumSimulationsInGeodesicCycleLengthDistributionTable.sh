#!/bin/sh
#
# File:    countNumSimulationsInGeodesicCycleLengthDistributionTable.sh
# Author:  Alex Stivala
# Created: February 2023
#
# Run the CYPATH and filteryclesGeodesic.py programs to get geodesic
# length distributions from a single network
# for reading in R and plotting etc.
#
# Usage: countNumSimulationsInGeodesicCycleLengthDistributionTable.sh
#
# Run in a dkseries/ or statnet_estimations/ subdirectory to count number of 
# simulated networks present
# in files crated by  makeGeodesicCycleLengthDistriubutionTables.sh
# (used as input plotCycleLengthDistributionsFromTables.R to plot results).
#
# Output is to stdout.
#
#
for i in *_geodesiccycledisttable.txt 
do
  echo -n "$i  "
  cat $i |grep '^[0-9]'| awk '{print $1}' | sort -n | uniq | wc -l
done
