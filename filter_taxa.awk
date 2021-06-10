#! /usr/bin/gawk -f
# How to run
# ./filter_taxa.awk /data/dictionary/database_groups.tsv > all_taxa_no_bacteria_archaea.tsv

BEGIN {
    FS="\t"
    selected_microbe_high_level_taxa[2]=1;      # tax id 2 stands for Bacteria
    selected_microbe_high_level_taxa[2157]=1;   # tax id  2157 stands for Archea
    #microbial eukayrotes to be added

}
# Load the data in associative arrays.

# load the database_groups.tsv from the dictionary and filter microbes only
(ARGIND==1 && $1==-2){

    all_taxa[$2]=1;

    if ($4 in selected_microbe_high_level_taxa){

        microbe_taxa[$2]=1;

        }

}
END{

    for (tax_id in all_taxa){

        if (!(tax_id in microbe_taxa)){

            print -2 "\t" tax_id;

        }
    }
}
