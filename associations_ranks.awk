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
# ./associations_statistics.awk 
#       /data/dictionary/prego_unicellular_ncbi.tsv \
#       /data/dictionary/ncbi/ncbi_taxonomy/nodes.dmp \
#       /data/textmining/database_pairs.tsv \
#       /data/dictionary/database_preferred.tsv \
#       /data/textmining/database_pairs.tsv \
#       /data/experiments/database_pairs.tsv \
#       /data/knowledge/database_pairs.tsv
# NOTE this script doesn't take into account score
###############################################################################
BEGIN {

    FS="\t"
    # Field names initialization of the first 4 columns for better readability
    #type_1=1; id_1=2; type_2=3; id_2=4
    superkingdoms["2"]="bacteria"
    superkingdoms["2157"]="archaea"
    }
# Load the data in associative arrays.

(ARGIND==1) {

    #initiate an array with the desired NCBI ids to count only microbes.
    unicellular_taxa[$2]=1

}

(ARGIND==2) {
    
    if ($5=="phylum"){
        phyla[$1];
    }
    if ($5=="family"){
        families[$1];
    }

}

(ARGIND==3){

    names[$2] = $3;

}

(ARGIND==4){

    if ($4 in phyla){
        child_phylum[$2] = $4;
    }

    if (($2 in unicellular_taxa) && ($4 in superkingdoms)){
        unicellular_superkingdom[$2] =superkingdoms[$4];
    }

}



# Load the NCBI taxonomy dump file with NCBI Ids and ranks.
#(ARGIND==2){
#
#    rank[$1]=$5;
#}

#Load all the database pairs files from all sources and channels of PREGO
(ARGIND>4 ){

    file = FILENAME
    # remove the NCBI_ID from the files
    gsub(/NCBI_ID:/, "", $0);
    
    if ($2 in unicellular_taxa){
        # count the taxa - environments associations first all together and then by
        # channer and source.
        # The textmining database_pairs file doesn't have a channel field so this
        # if searches whether the file comes from textmining 
        # Here a multidimentional array is created that counts the number of 
        # associations per file, channel and types

        #phylum = child_phylum[$2]
        #superkingdoms = unicellular_superkingdom[$2]

        total_associations[$type_1][$type_2]++
        #total_associations_taxonomy[$type_1][$type_2][rank[$id_1]]++
        total_associations_taxonomy[$type_1][$type_2][unicellular_superkingdom[$2]][child_phylum[$2]]++
      
        if (file ~ /textmining/) {
            associations[file]["textmining"][$type_1][$type_2]++
            if ($type_1 == -2){
                #associations_taxonomy[file]["textmining"][$type_1][$type_2][rank[$id_1]]++
                associations_taxonomy[file]["textmining"][$type_1][$type_2][unicellular_superkingdom[$2]][child_phylum[$2]]++
            }
            }
        }
        else {
            associations[file][$5][$type_1][$type_2]++
            if ($type_1 == -2){
                #associations_taxonomy[file][$5][$type_1][$type_2][rank[$id_1]]++
                associations_taxonomy[file][$5][$type_1][$type_2][unicellular_superkingdom[$2]][child_phylum[$2]]++
            }

    }
}
END{

    print "file" FS "channel" FS "type 1" FS "type 2" FS "superkingdom" FS "phylum" FS "# associations"

    for (type1 in total_associations){
        for (type2 in total_associations[type1]){

            print "all" FS "all" FS type1 FS type2 FS "total" FS total_associations[type1][type2]

            for (kingdom in total_associations_taxonomy[type1][type2]){

                for (phylum in total_associations[type1][type2][kingdom]) {

                    print "all" FS "all" FS type1 FS type2 FS kingdom FS phylum FS total_associations_taxonomy[type1][type2][kingdom][phylum]
                }
            }
        }
    }

#    for (file in associations){
#        for (channel in associations[file]){
#            for (type1 in associations[file][channel]){
#                for (type2 in associations[file][channel][type1]){
#                    print file FS channel FS type1 FS type2 FS "total" FS associations[file][channel][type1][type2]
#
#                    for (taxonomy in associations_taxonomy[file][channel][type1][type2]){
#
#                        print file FS channel FS type1 FS type2 FS taxonomy FS associations_taxonomy[file][channel][type1][type2][taxonomy]
#
#                    }
#                }
#            }
#        }
#    }
}

