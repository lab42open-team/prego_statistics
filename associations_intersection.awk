#! /usr/bin/gawk -f

###############################################################################
# script name: associations_intersection.awk
# path on oxygen: /data/databases/scripts/prego_statistics/
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
###############################################################################
# GOAL:
# Aim of this script is to calculate the contents of the associations pairs 
# from all the prediction channels, text mining, experiments and knowledge.
# There are terms of NCBI ids, ENVO ids, GO ids as well as their associations.
# NOTE: this script is for ALL associations regardless their score!!!
###############################################################################
#
# usage:./associations_intersection.awk \ 
# /data/dictionary/prego_unicellular_ncbi.tsv \
# /data/dictionary/ncbi/ncbi_taxonomy/nodes.dmp \
# /data/textmining/database_pairs.tsv /data/experiments/database_pairs.tsv \
# /data/knowledge/database_pairs.tsv
#
###############################################################################
BEGIN {
    FS="\t"
}
# Load the data in associative arrays.

(ARGIND==1) {

    #initiate an array with the desired NCBI ids to include only microbes.
    unicellular_taxa[$2]=1

}
# Load the third file, NCBI taxonomy dump file with NCBI Ids and ranks.
(ARGIND==2){

    rank[$1]=$5;
}
#Load all the database pairs files from all sources and channels of PREGO
(ARGIND>2){

    # keep the channel name from the FILENAME and add it in the array
    channels = gensub(/\/(.+)\/(.+)\/(.+)/,"\\2","g" ,FILENAME)

    # The second dimension of the array is the type of the association, variabe $3
    # The third dimension of the array is the ncbi id. 
    # The value of this multidimentional array is the number of associations 
    # of a NCBI id with a specific type (i.e -21, -27) of a specific channel.

    if ($1 == "-27"){

        if ($3==-2){

            if ($4 in unicellular_taxa){

                environments_associations[channels][$3][$2]++;
            }
        }
        else {
            environments_associations[channels][$3][$2]++;
        }
    }

    if ($1 == "-21"){

        if ($3==-2){

            if ($4 in unicellular_taxa){

                processes_associations[channels][$3][$2]++;
            }
        }
        else {

            processes_associations[channels][$3][$2]++;

        }
    }

    if ($1 == "-2" && $2 in unicellular_taxa){

        taxa_associations[channels][$3][$2]++;

    }

}
# Print the results
END{

    for (channel in taxa_associations){

        for (type2 in taxa_associations[channel]){

            for (taxon in taxa_associations[channel][type2]){

                print "-2" "\t" taxon "\t" taxa_associations[channel][type2][taxon] "\t" type2 "\t" channel "\t" rank[taxon]

            }
        }
    }
    for (channel in environments_associations){

        for (type2 in environmets_associations[channel]){

            for (env in environmets_associations[channel][type2]){

                print "-27" "\t" env "\t" environments_associations[channel][type2][env] "\t" type2 "\t" channel "\t" "na"

            }
        }
    }
    for (channel in processes_associations){

        for (type2 in processes_associations[channel]){

            for (proc in processes_associations[channel][type2]){

                print "-21" "\t" proc "\t" processes_associations[channel][type2][proc] "\t" type2 "\t" channel "\t" "na"

            }
        }
    }
}

