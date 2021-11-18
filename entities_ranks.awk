#! /usr/bin/gawk -f

###############################################################################
# script name: entities_ranks.awk
# path on oxygen: /data/databases/scripts/prego_statistics/
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
# usage:  ./entities_ranks.awk 
# /data/dictionary/prego_unicellular_ncbi.tsv \
# /data/dictionary/ncbi/ncbi_taxonomy/nodes.dmp\ 
# /data/dictionary/database_preferred.tsv \
# /data/dictionary/database_groups.tsv \
# /data/experiments/database_pairs.tsv
###############################################################################

BEGIN {
    FS="\t"
    # Field names for better readability
    #type_1=1; id_1=2; type_2=3; id_2=4; source=5 ; evidence=7; score=6; 
    #explicit=7 ; url=8;
    superkingdoms["2"]="bacteria"
    superkingdoms["2157"]="archaea"
    #superkingdoms[2]="eukarya"

    }
# Load the data in associative arrays.
(ARGIND==1) {

    #initiate an array with the desired NCBI ids to count only microbes.
    unicellular_taxa[$2]=1

}
# Load the third file and fourth file for the higher taxonomy.
(ARGIND==2 ){
    if ($5=="phylum"){
        phyla[$1];
    }
    
    if ($5=="family"){
        families[$1];
    }
}
# load database_preferred.tsv
(ARGIND==3){
    names[$2]=$3
}
#load database_groups
(ARGIND==4){
    if ($4 in phyla){
        child_phylum[$2]=$4 # is this unique? and why? because we kept only phyla
                            # in higher taxa
    }
    if ($4 in families){
        child_family[$2]=$4
    }
    if (($2 in unicellular_taxa) && ($4 in superkingdoms)){
        unicellular_superkingdom[$2]=superkingdoms[$4];

    }
}
#Load all the rest files
(ARGIND>4){

    file = FILENAME

    if (($2 in unicellular_taxa) || ($4 in unicellular_taxa)){
        if ($1 == -2){
            if ($2 in unicellular_superkingdom){
                entities["all"]["all"][$1][child_phylum[$2]][unicellular_superkingdom[$2]][$2]=1
                entities["all"]["all"][$1]["all"][unicellular_superkingdom[$2]][$2]=1
                entities["all"]["all"][$3][child_phylum[$2]][unicellular_superkingdom[$2]][$4]=1
                entities["all"]["all"][$3]["no rank"]["no rank"][$4]=1
            }
            if (!($2 in unicellular_superkingdom)){
                entities["all"]["all"][$1][child_phylum[$2]]["eukaryotes"][$2]=1
                entities["all"]["all"][$1]["all"]["eukaryotes"][$2]=1
                entities["all"]["all"][$3][child_phylum[$2]]["eukaryotes"][$4]=1
            }
        }
        # Text mining file doesn't have a source field so this condition
        # checks whether the path has the word textmining
        if (file ~ /textmining/) {
            # Only taxa have a rank for the moment so we have to condition
            # that as well.
            if ($1 == -2){
                if ($2 in unicellular_superkingdom){
                    entities[file]["textmining"][$1][child_phylum[$2]][unicellular_superkingdom[$2]][$2]=1
                    entities[file]["textmining"][$1]["all"][unicellular_superkingdom[$2]][$2]=1
                    entities[file]["textmining"][$3][child_phylum[$2]][unicellular_superkingdom[$2]][$4]=1
                    entities[file]["textmining"][$3]["no rank"][unicellular_superkingdom[$2]][$4]=1
                } 
                if (!($2 in unicellular_superkingdom)){
                    entities[file]["textmining"][$1][child_phylum[$2]]["eukaryotes"][$2]=1
                    entities[file]["textmining"][$1]["all"]["eukaryotes"][$2]=1
                    entities[file]["textmining"][$3][child_phylum[$2]]["eukaryotes"][$4]=1
                }
            }
        }
        else {
            if ($1 == -2){
                if ($2 in unicellular_superkingdom){
                    entities[file][$5][$1][child_phylum[$2]][unicellular_superkingdom[$2]][$2]=1
                    entities[file][$5][$1]["all"][unicellular_superkingdom[$2]][$2]=1
                    #count the entities associated with -2. There are cases where
                    #the associations are not symmetric between entities.
                    entities[file][$5][$3][child_phylum[$2]][unicellular_superkingdom[$2]][$4]=1
                    entities[file][$5][$3]["no rank"][unicellular_superkingdom[$2]][$4]=1
                }
                if (!($2 in unicellular_superkingdom)){
                    entities[file][$5][$1][child_phylum[$2]]["eukaryotes"][$2]=1
                    entities[file][$5][$1]["all"]["eukaryotes"][$2]=1
                    entities[file][$5][$3][child_phylum[$2]]["eukaryotes"][$4]=1
                }
            }
        }
    }
}
#print statistics for each source.
END{ 

    print "file" FS "channel" FS "type" FS "phylum_id" FS "superkingdom" FS "phylum_name" FS "no_entities"

    for (file in entities){

        for (channel in entities[file]){

            for (type in entities[file][channel]){

                for (phylum_id in entities[file][channel][type]){

                    for (superkingdom in entities[file][channel][type][phylum_id]){
                        print file FS channel FS type FS phylum_id FS superkingdom FS names[phylum_id] FS length(entities[file][channel][type][phylum_id][superkingdom])
                    }

                }
            }
        }
    }
}

