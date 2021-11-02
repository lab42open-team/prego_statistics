#! /usr/bin/gawk -f
###############################################################################
# script name: pubmed_statistics.awk
# path on oxygen: /data/databases/scripts/prego_statistics/
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
###############################################################################
# GOAL:
# Aim of this script is to calculate the contents of PubMed that is downloaded 
# on oxygen and is used for textmining. 
# Checks for duplicated Ids and empty fields.
###############################################################################
#
# usage: 
# gunzip -c /data/databases/pubmed/pubmed*.tsv.gz | ./pubmed_statistics.awk
#
###############################################################################
BEGIN {
    FS="\t"
    # Field names
    id=1; authors=2; journal=3 ; year=4 ;title=5; abstract=6

}
# count all ids of pubmed abstracts
{times[$1]++}

#count all ids of pubmed abstracts that have year and text
($year!~/null/ && $abstract!~/null/){full_info[$1]=$0}
END{
    print "Unique abstracts" "\t" length(times); 
    for (i in times){sum+=times[i]}; 
    print "Total abstracts" "\t" sum ; 
    print "Abstracts with year and abstract" "\t" length(full_info)
}

