#!/usr/bin/python

# This script takes as input all the database_pairs.tsv from the 3 channels
# and returns the taxa that have associations in all of them with Environments
# and Processes

import sys
import csv



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

        if line[0] in unicellular_taxa:

            rank[line[0]]=line[2]

textmining_pairs = []

channel = ["textmining", "experiments", "knowledge"]
pairs_file = "/data/" + str(channel[0]) + "/database_pairs.tsv"
#with open("/data/textmining/database_pairs.tsv") as textmining_file:
with open(pairs_file) as textmining_file:

    for line in textmining_file:
        line = line.rstrip("\n").split("\t")

        if (line[0]=="-2") and (line[1] in unicellular_taxa):
            textmining_pairs.append(line)

textmining ={}
textmining['-27'] = {}
textmining['-21'] = {}

for line in textmining_pairs:

    if line[2]=="-27":
        
        if line[1] in textmining['-27'].keys():

            textmining['-27'][line[1]]=textmining['-27'][line[1]]+1

        else:

            textmining['-27'][line[1]]=1

    if line[2]=="-21":
        
        if line[1] in textmining['-21'].keys():

            textmining['-21'][line[1]]=textmining['-21'][line[1]]+1

        else:

            textmining['-21'][line[1]]=1


with open('output.tsv','wt') as out_file:
    tsv_writer = csv.writer(out_file, delimiter='\t')
    
    for k in textmining:
    
        for j in textmining[k]:
    
            if j in rank.keys():

                tsv_writer.writerow([j,k,channel[0],textmining[k][j], rank[j]])

            else:

                tsv_writer.writerow([j,k,channel[0],textmining[k][j], "NA"])




