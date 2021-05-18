#! /usr/bin/gawk -f
########################################################################################
# script name: pubmed_statistics.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
########################################################################################
# GOAL:
# Aim of this script is to calculate the contents of PubMed that is downloaded on oxygen
# and is used for textmining. Checks for duplicated Ids and empty fields.
########################################################################################
#
# usage: gunzip -c /data/databases/pubmed/pubmed*.tsv.gz | ./pubmed_statistics.awk
#
############################################################################################
BEGIN {
    FS="\t"
    # Field names
    id=1; authors=2; journal=3 ; year=4 ;title=5; abstract=6

    }
{times[$1]++}
($year!~/null/ && $abstract!~/null/){full_info[$1]=$0}
END{print "Unique abstracts" "\t" length(times); for (i in times){sum+=times[i]}; print "Total abstracts" "\t" sum ; print "Abstracts with year and abstract" "\t" length(full_info)}

#cd /data/databases/pubmed
#ls -1 | awk '{sub(/\./," ")}1' | awk '{gsub(/_stats/,"",$1); print $2}' | sort | uniq -c

#more pubmed_ids.tsv | gawk '!seen[$0]++' | wc -l 
