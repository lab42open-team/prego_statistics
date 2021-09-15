#! /usr/bin/gawk -f

###############################################################################
# script name: associations_intersection.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
###############################################################################
# GOAL:
# Aim of this script is to calculate the contents of the associations pairs 
# from all the prediction channels, text mining, experiments and knowledge.
# Theare  terms of NCBI ids, ENVO ids, GO ids as well as their assotiations.
# NOTE: this script is for ALL associations regardless their score!!!
###############################################################################
#
# usage:./associations_intersection.awk /data/dictionary/prego_unicellular_ncbi.tsv /data/dictionary/database_groups.tsv nodes.dmp \
# /data/textmining/database_pairs.tsv /data/experiments/database_pairs.tsv \
# /data/knowledge/database_pairs.tsv
#
###############################################################################
BEGIN {
    FS="\t"
    type_1=1; id_1=2; type_2=3; id_2=4; z_score=5; score=6

}
# Load the data in associative arrays.

(ARGIND==1) {

    #initiate an array with the desired NCBI ids to count only microbes.
    unicellular_taxa[$2]=1

}
# load the database_groups.tsv from the dictionary and filter microbes only
(ARGIND==2 && $1==-2 && ($4 in unicellular_taxa)){

    microbes[$2]=$4

}
# Load the third file, NCBI taxonomy dump file with NCBI Ids and ranks.
(ARGIND==3){

    rank[$1]=$5;
}
#Load all the database pairs files from all sources and channels of PREGO
(ARGIND>3 && $type_1 == -2 && ($2 in microbes)){

    channels = gensub(/\/(.+)\/(.+)\/(.+)/,"\\2","g" ,FILENAME)

    # count the taxa - environments associations
        
    taxa_associations[channels][$3][$2]++;

}
END{

    for (channel in taxa_associations){

        for (type2 in taxa_associations[channel]){

            for (taxon in taxa_associations[channel][type2]){

                print taxon "\t" taxa_associations[channel][type2][taxon] "\t" type2 "\t" channel "\t" rank[taxon]

            }
        }
    }
}

