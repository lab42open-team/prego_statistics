#!/usr/bin/python

# This script takes as input all the database_pairs.tsv from the 3 channels
# and returns the taxa that have associations in all of them with Environments
# and Processes

import sys

# Load the unicellular taxa in dictionary
unicellular_taxa = {}

with open("/data/dictionary/prego_unicellular_ncbi.tsv") as unicellular_file:
    
    for line in unicellular_file:
        line = line.rstrip("\n").split('\t')

        unicellular_taxa[line[1]]=1

# Load each channel data into an individual dictionary to find the intersection

# Load the nodes.dmp file for the taxonomy
rank = {}
with open("nodes.dmp") as ranks:

    for line in ranks:
        line = line.rstrip("\n").split('\t|\t')

        rank[line[0]]=line[2]

for i in unicellular_taxa:


    print(i, "\t", rank[i])
