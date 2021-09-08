#! /usr/bin/gawk -f
# This script creates a tsv file with all the NCBI ids that are NOT microbes and
# thus have to be moved to hidden file.
# How to run
# ./filter_taxa.awk METdb_GENOMIC_REFERENCE_DATABASE_FOR_MARINE_SPECIES.csv /data/dictionary/database_groups.tsv > all_taxa_no_bacteria_archaea.tsv

BEGIN {
    ## Two conditional field separators. CAREFUL! 
    FS="[\t,]"
    
    # Select organisms manually
    selected_microbe_high_level_taxa[2]=1;      # tax id 2 stands for Bacteria
    selected_microbe_high_level_taxa[2157]=1;   # tax id 2157 stands for Archea

    ## Microbial - Unicellular Eukaryotes

    ## From supergroup Excavata

    selected_microbe_high_level_taxa[5719]=1;   # tax id 5719 stands for phylum Parabasalia
    selected_microbe_high_level_taxa[5738]=1;   # tax id 5738 stands for order Diplomonadida
    selected_microbe_high_level_taxa[66288]=1;   # tax id 66288 stands for order Oxymonadida
    selected_microbe_high_level_taxa[193075]=1;   # tax id 193075 stands for family Retortamonadidae
    selected_microbe_high_level_taxa[2611341]=1;   # tax id 2611341 stands for clade Metamonada
    selected_microbe_high_level_taxa[207245]=1;   # tax id 207245 stands for plylum Fornicata
    selected_microbe_high_level_taxa[136087]=1;   # tax id 136087 stands for family Malawimonadidae
    selected_microbe_high_level_taxa[85705]=1;   # tax id 85705 stands for family Ancyromonadidae
    selected_microbe_high_level_taxa[1294546]=1;   # tax id 1294546 stands for family Planomonadidae


    ### From supergroup Excavata, clade Discoba
    selected_microbe_high_level_taxa[33682]=1;   # tax id 2157 stands for phylum Euglenozoa
    selected_microbe_high_level_taxa[5752]=1;   # tax id 5752 stands for phylum Heterolobosea
    selected_microbe_high_level_taxa[556282]=1;   # tax id 556282 stands for order Jakobida
    selected_microbe_high_level_taxa[2711297]=1;   # tax id 2711297 stands for order Tsukubamonadida

    ## From supergroup Archaeplastida

    selected_microbe_high_level_taxa[38254]=1;   # tax id 38254 stands for class Glaucocystophyceae
    
    ### Rhodophycea, red algae
    selected_microbe_high_level_taxa[265318]=1;   # tax id 265318 stands for order Cyanidiales
    selected_microbe_high_level_taxa[2798]=1;   # tax id 2798 stands for order Porphyridiales
    selected_microbe_high_level_taxa[661027]=1;   # tax id 661027 stands for class Rhodellophyceae
    selected_microbe_high_level_taxa[446134]=1;   # tax id 446134 stands for class Stylonematophyceae

    ## From Chloroplastida / Viridiplantae
    selected_microbe_high_level_taxa[3166]=1;   # tax id 3166 stands for class Chloropphyceae
    selected_microbe_high_level_taxa[2201463]=1;   # tax id 2201463 stands for class Palmophyllophyceae, synonym of Prasinophyceae
    selected_microbe_high_level_taxa[3166]=1;   # tax id 3166 stands for class Chloropphyceae
    selected_microbe_high_level_taxa[3166]=1;   # tax id 3166 stands for class Chloropphyceae

    ## From Chromalveolata

    ### Alveolata
    
    selected_microbe_high_level_taxa[2864]=1;   # tax id 2864 stands for class Dinophyceae
    selected_microbe_high_level_taxa[5794]=1;   # tax id 5794 stands for class Apicomplexa
    selected_microbe_high_level_taxa[5878]=1;   # tax id 5878 stands for phylum Ciliophora
    selected_microbe_high_level_taxa[]=1;   # tax id 5878 stands for phylum Ciliophora

    ### Stramenopiles
 
    selected_microbe_high_level_taxa[238765]=1;   # tax id 238765 stands for class Actinophryidae
    selected_microbe_high_level_taxa[33849]=1;   # tax id 33849 stands for class Bacillariophyceae
    selected_microbe_high_level_taxa[35131]=1;   # tax id 35131 stands for class Labyrinthulomycetes
    selected_microbe_high_level_taxa[33651]=1;   # tax id 33651 stands for order Bicosoecida

    ### Chromobionta
    selected_microbe_high_level_taxa[2833]=1;   # tax id 2833 stands for class Xanthophyceae
    selected_microbe_high_level_taxa[38410]=1;   # tax id 38410 stands for class Raphidophyceae
    selected_microbe_high_level_taxa[157124]=1;   # tax id 157124 stands for class Pinguiophyceae
    selected_microbe_high_level_taxa[33849]=1;   # tax id 33849 stands for class Bacillariophyceae
    selected_microbe_high_level_taxa[589449]=1;   # tax id 589449 stands for class Mediophyceae
    selected_microbe_high_level_taxa[33836]=1;   # tax id 33836 stands for class Coscinodiscophyceae
    selected_microbe_high_level_taxa[91989]=1;   # tax id 91989 stands for class Bolidophyceae
    selected_microbe_high_level_taxa[35675]=1;   # tax id 35675 stands for class Pelagophyceae
    selected_microbe_high_level_taxa[2825]=1;   # tax id 2825 stands for class Chrysophyceae
    selected_microbe_high_level_taxa[33859]=1;   # tax id 33859 stands for class Synurophyceae
    selected_microbe_high_level_taxa[557229]=1;   # tax id 557229 stands for class Synchromophyceae
    selected_microbe_high_level_taxa[2825]=1;   # tax id 2825 stands for class Chrysophyceae
    selected_microbe_high_level_taxa[39119]=1;   # tax id 39119 stands for class Dictyochophyceae

    ### Haptophyta
    selected_microbe_high_level_taxa[2830]=1;   # tax id 2830 stands for class Haptophyta

    ## Unikonts

    ### Opistrhokonta

    ### Amoebozoa

    ## Cryptobionta

    ## Rhizaria

    ## Discicristates


}
# Load the METdb A GENOMIC REFERENCE DATABASE FOR MARINE SPECIES data in associative array.
(ARGIND==1 && NR>1){
    
    gsub(/"/,"",$10)
    selected_microbe_high_level_taxa[$10]=1;

}
# load the database_groups.tsv from the dictionary and filter microbes only
(ARGIND==2 && $1==-2){

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
