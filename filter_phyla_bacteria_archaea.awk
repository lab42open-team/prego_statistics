#! /usr/bin/gawk -f
###############################################################################
# script name: filter_phyla_bacteria_achaea.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
###############################################################################
# GOAL: Keep all the phyla from Bacteria and archaea in order to do further 
# calculations
###############################################################################
# How to run:
# ./filter_phyla_bacteria_archaea.awk data/dictionary/database_groups.tsv \
# /data/dictionary/ncbi/ncbi_taxonomy/nodes.dmp > phyla_bacteria_archaea.tsv
###############################################################################
BEGIN{
    FS="\t"
    high_level_taxa[2]=1;
    high_level_taxa[2157]=1
}
# load the database_groups.tsv from the dictionary and filter all children of 
# Bacteria and Archaea
(NR==FNR){
    if ($4 in high_level_taxa){
        children[$4][$2]=1}
}
#load the nodes.dmp file from ncbi to keep the rank. 
{
    ranks[$1]=$5
}
END{
#print only the NCBI ids that are phyla.
    for (p in children){ 
        for (i in children[p]){
            if (ranks[i]=="phylum"){
                print -2 FS i FS ranks[i] FS p
            }
        }
    }
}
