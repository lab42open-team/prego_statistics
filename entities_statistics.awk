#! /usr/bin/gawk -f

###############################################################################
# script name: entities_statistics.awk
# path on oxygen: /data/databases/scripts/prego_statistics
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
###############################################################################
# GOAL:
# Aim of this script is to calculate the entities and their associations across
# channels and files. 
# Also the contents taxominic rank
# NOTE: this script is for ALL associations regardless their score!!!
###############################################################################
#
# usage:
# ./entities_statistics.awk /data/dictionary/prego_unicellular_ncbi.tsv \
# /data/dictionary/ncbi/ncbi_taxonomy/nodes.dmp \
# /data/experiments/database_pairs.tsv /data/textmining/database_pairs.tsv \
# /data/knowledge/database_pairs.tsv
###############################################################################

BEGIN {
    FS="\t"
    # Field names for better readability
    #type_1=1; id_1=2; type_2=3; id_2=4; source=5 ; evidence=7; score=6; 
    #explicit=7 ; url=8;

    }
# Load the data in associative arrays.
(ARGIND==1) {

    #initiate an array with the desired NCBI ids to count only microbes.
    unicellular_taxa[$2]=1

}
# Load the third file, NCBI taxonomy dump file with NCBI Ids and ranks.
(ARGIND==2){
    rank[$1]=$5;
}
#Load all the rest files
(ARGIND>2){

    file = FILENAME

    if (($2 in unicellular_taxa) || ($4 in unicellular_taxa)){
        if ($1 == -2){
            entities["all"]["all"][$1][rank[$2]][$2]=1
            entities["all"]["all"][$1]["all"][$2]=1
            entities["all"]["all"][$3]["no rank"][$4]=1
        }
        else{
            entities["all"]["all"][$1]["no rank"][$2]=1
        }
        # Text mining file doesn't have a source field so this condition
        # checks whether the path has the word textmining
        if (file ~ /textmining/) {
            # Only taxa have a rank for the moment so we have to condition
            # that as well.
            if ($1 == -2){
               entities[file]["textmining"][$1][rank[$2]][$2]=1
               entities[file]["textmining"][$1]["all"][$2]=1
            }
            else{
                entities[file]["textmining"][$1]["no rank"][$2]=1
            }
        }
        else {
            if ($1 == -2){
                entities[file][$5][$1][rank[$2]][$2]=1
                entities[file][$5][$1]["all"][$2]=1
                #count the entities associated with -2. There are cases where
                #the associations are not symmetric between entities.
                entities[file][$5][$3]["no rank"][$4]=1
            }
            else{
                entities[file][$5][$1]["no rank"][$2]=1
            }
        }
    }
}
#print statistics for each source.
END{ 

    print "file" FS "channel" FS "type" FS "taxonomy" FS "Unique entities"

    for (file in entities){

        for (channel in entities[file]){

            for (type in entities[file][channel]){

                for (taxonomy in entities[file][channel][type]){

                    print file FS channel FS type FS taxonomy FS length(entities[file][channel][type][taxonomy])

                }
            }
        }
    }
}

