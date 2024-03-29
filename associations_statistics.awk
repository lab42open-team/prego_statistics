#! /usr/bin/gawk -f

###############################################################################
# script name: associations_statistics.awk
# path on oxygen: /data/databases/scripts/prego_statistics
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
# usage:
# ./associations_statistics.awk /data/dictionary/prego_unicellular_ncbi.tsv \
# /data/dictionary/ncbi/ncbi_taxonomy/nodes.dmp \
# /data/textmining/database_pairs.tsv /data/experiments/database_pairs.tsv \
# /data/knowledge/database_pairs.tsv
# NOTE this script doesn't take into account score
###############################################################################
BEGIN{

    FS="\t"
# Load the data in associative arrays.
}
(ARGIND==1) {

    #initiate an array with the desired NCBI ids to count only microbes.
    unicellular_taxa[$2]=1

}
# Load the second file, NCBI taxonomy dump file with NCBI Ids and ranks.
(ARGIND==2){

    rank[$1]=$5;
}
#Load all the database pairs files from all sources and channels of PREGO
(ARGIND>2 ){

    file = FILENAME
    
    # count the taxa - environments associations first all together and then by
    # channer and source.
    # The textmining database_pairs file doesn't have a channel field so this
    # if searches whether the file comes from textmining 
    # Here a multidimentional array is created that counts the number of 
    # associations per file, channel and types

    total_associations[$1][$3]++
    
    if ($1==-2 && ($2 in unicellular_taxa)){
        total_associations_taxonomy[$1][$3][rank[$2]]++
    }
    if (file ~ /textmining/) {
        associations[file]["textmining"][$1][$3]++
        # taxonomy counts
        if ($1==-2 && ($2 in unicellular_taxa)){

            associations_taxonomy[file]["textmining"][$1][$3][rank[$2]]++
        }
    }
    else {
        associations[file][$5][$1][$3]++
        
        # taxonomy counts
        if ($1==-2 && ($2 in unicellular_taxa)){
            associations_taxonomy[file][$5][$1][$3][rank[$2]]++
        }
    }
}
END{

    print "file" FS "channel" FS "type 1" FS "type 2" FS "taxonomy" FS "# associations"

    for (type1 in total_associations){
        for (type2 in total_associations[type1]){
            print "all" FS "all" FS type1 FS type2 FS "total" FS total_associations[type1][type2]

            if (type1==-2){
                for (taxonomy in total_associations_taxonomy[type1][type2]){

                    print "all" FS "all" FS type1 FS type2 FS taxonomy FS total_associations_taxonomy[type1][type2][taxonomy]
                }
            }
        }
    }

    for (file in associations){
        for (channel in associations[file]){
            for (type1 in associations[file][channel]){
                for (type2 in associations[file][channel][type1]){
                    print file FS channel FS type1 FS type2 FS "total" FS associations[file][channel][type1][type2]

                    if (type1==-2){

                        for (taxonomy in associations_taxonomy[file][channel][type1][type2]){

                            print file FS channel FS type1 FS type2 FS taxonomy FS associations_taxonomy[file][channel][type1][type2][taxonomy]
                        }
                    }
                }
            }
        }
    }
}

