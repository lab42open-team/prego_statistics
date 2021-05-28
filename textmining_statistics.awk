#! /usr/bin/gawk -f

###############################################################################
# script name: textmining_statistics_microbes.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
###############################################################################
# GOAL:
# Aim of this script is to calculate the contents of the textmining 
# associations pairs in terms of NCBI ids, ENVO ids, GO ids and their 
# assotiations. Also the contents taxominic rank
# NOTE: this script is for ALL associations regardless their score!!!
###############################################################################
#
# usage: ./textmining_statistics_microbes.awk \
# /data/dictionary/database_groups.tsv /data/textmining/database_pairs.tsv \
# nodes.dmp
#
###############################################################################
BEGIN {
    FS="\t"
    # Field names initialization for better readability
    #type_1=1; id_1=2; type_2=3; id_2=4; z_score=5; score=6

    }
# load the database_groups.tsv from the dictionary and filter microbes only
(ARGIND==1 && $1==-2 && ($4==2 || $4==2157)){

    microbes[$2]=$4

}
# Load the data in associative arrays.
# Load the first input file, the associations.  
# filter the taxa (-2) to process the taxa interactions with environments 
# (-27) and processes (-21)
(ARGIND==2 && $1==-2){

    if ($2 in microbes) {

        # count the taxa - environments associations
        if ($3==-27){
            
            taxa_env[$2" "$4]++;
            taxa[$2]=$0;
            env[$4]++;

            }
        # count the taxa - processes associations
        else if ($3==-21){

            proc[$4]++;
            taxa[$2]=$0;
            taxa_proc[$2" "$4]++;
            }

        }
    }
# Load the second file, NCBI taxonomy dump file with NCBI Ids and ranks.
(ARGIND==3){

    rank[$1]=$5;
}
END{

    print "source" "\t" "Unique taxa" "\t" "Unique environments" \
             "\t" "Unique processes" "\t" "Taxa associations with Environments"\
             "\t" "Taxa associations with processes" "\t" "Total interactions";

    print  "text mining" "\t" length(taxa) "\t" length(env) "\t" length(proc)\
              "\t" length(taxa_env) "\t" length(taxa_proc) "\t" \
              length(taxa_proc)+length(taxa_env);
    
    print "microbes" "\t" length(microbes)

    for (j in taxa){
             
        taxa_rank[rank[j]]++
        taxonomy[microbes[j]]++
        print j "\t" taxa[j]
    }

    for (r in taxa_rank){

        print r "\t" taxa_rank[r]
    }

    for (m in taxonomy){

        print m "\t" taxonomy[m]
    }
}

