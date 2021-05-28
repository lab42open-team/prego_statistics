#! /usr/bin/gawk -f

########################################################################################
# script name: textmining_statistics.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
########################################################################################
# GOAL:
# Aim of this script is to calculate the contents of the textmining associations pairs
# in terms of NCBI ids, ENVO ids, GO ids and their assotiations. Also the contents
# taxominic rank
# NOTE: this script is for ALL associations regardless their score!!!
########################################################################################
#
# usage: ./textmining_statistics.awk /data/textmining/database_pairs.tsv nodes.dmp
#
############################################################################################
BEGIN {
    FS="\t"
    # Field names initialization for better readability
    type_1=1; id_1=2; type_2=3; id_2=4; z_score=5; score=6

    }
# Load the first input file, the associations. And filter the taxa (-2) to process the taxa interactions with environments (-27) and processes (-21)
# Load the data in associative arrays.

(NR ==FNR && $type_1 == -2){

    taxa[$id_1]=$0

    # count the taxa - environments associations
    if ($type_2 == -27){
        
        taxa_env[$id_1" "$id_2]++;
        env[$id_2]++;

    }
    # count the taxa - processes associations
    else if ($type_2 == -21){

        proc[$id_2]++;
        taxa_proc[$id_1" "$id_2]++;
    }
}
# Load the second file, NCBI taxonomy dump file with NCBI Ids and ranks.
{

    rank[$1]=$5;
}
END{print "source" "\t" "Unique taxa" "\t" "Unique environments" "\t" "Unique processes" "\t" "Taxa associations with Environments" "\t" "Taxa associations with processes" "\t" "Total interactions";

    print  "text mining" "\t" length(taxa) "\t" length(env) "\t" length(proc) "\t" length(taxa_env) "\t" length(taxa_proc) "\t" length(taxa_proc)+length(taxa_env);


    for (j in taxa){
             
        taxa_rank[rank[j]]++
    }

    for (r in taxa_rank){

        print r "\t" taxa_rank[r]
    }
}
