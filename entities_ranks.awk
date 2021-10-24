#! /usr/bin/gawk -f

###############################################################################
# script name: entities_ranks.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
###############################################################################
# GOAL:
# Aim of this script is to calculate the entities of higher included in higher 
# levels across sources, channels and files. Phyla for taxa, second level of
# KEGG orhology metabolism and custom selections for ENVO and Biological 
# Process.
# NOTE: this script is for ALL associations regardless their score!!!
###############################################################################
#
# usage:  ./entities_ranks.awk /data/dictionary/prego_unicellular_ncbi.tsv \
# /data/dictionary/ncbi/nodes.dmp /data/experiments/database_pairs.tsv
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
# Load the third file and fourth file for the higher taxonomy.
(ARGIND==2){
    higher_taxa[$2]=$3"\t"$4;
}
(ARGIND==3){
    higher_taxa[$2]=$3"\t"$4;
}
# load database_preferred.tsv
(ARGIND==4){
    names[$2]=$3
}
#load database_groups
(ARGIND==5){
    if ($4 in higher_taxa){
    child_parent[$2]=$4 # is this unique? and why?
    }
}
#Load all the rest files
(ARGIND>5){

    file = FILENAME

    if (($2 in unicellular_taxa) || ($4 in unicellular_taxa)){
        if ($1 == -2){
            entities["all"]["all"][$1][child_parent[$2]][$2]=1
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
               entities[file]["textmining"][$1][child_parent[$2]][$2]=1
               entities[file]["textmining"][$1]["all"][$2]=1
            }
            else{
                entities[file]["textmining"][$1]["no rank"][$2]=1
            }
        }
        else {
            if ($1 == -2){
                entities[file][$5][$1][child_parent[$2]][$2]=1
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

    print "file" FS "channel" FS "type" FS "higher taxonomy" FS "superkingdom" FS "name" FS "#entities"

    for (file in entities){

        for (channel in entities[file]){

            for (type in entities[file][channel]){

                for (taxonomy in entities[file][channel][type]){

                    print file FS channel FS type FS taxonomy FS names[taxonomy] FS higher_taxa[taxonomy] FS length(entities[file][channel][type][taxonomy])

                }
            }
        }
    }
}

