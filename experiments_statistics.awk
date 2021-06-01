#! /usr/bin/gawk -f

###############################################################################
# script name: experiments_statistics.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
###############################################################################
# GOAL:
# Aim of this script is to calculate the contents of the associations pairs 
# derived from different sources of MGnify and MG-RAST
# in terms of NCBI ids, ENVO ids, GO ids and their assotiations. 
# Also the contents taxominic rank
# NOTE: this script is for ALL associations regardless their score!!!
###############################################################################
#
# usage:  ./experiments_statistics.awk \
# /data/dictionary/database_groups.tsv /data/experiments/database_pairs.tsv \
# nodes.dmp
#
###############################################################################

BEGIN {
    FS="\t"
    # Field names
    #type_1=1; id_1=2; type_2=3; id_2=4; source=5; evidence=6; score=7; 
    #explicit=8; url=9
    #initiate an array with the desired NCBI ids to count only microbes.
    microbe_taxa[2]=1;
    microbe_taxa[2157]=1;
    source_db["MGnify"]=1;
    source_db["MG-RAST"]=1;

    }
# load half the file for organisms only. 
# The NR==FNR is true only for the first file.
# Load the first input file, the associations. And filter the taxa (-2) 
# to process the taxa interactions with environments (-27) and processes (-21)
# there are 2 sources of Experiments: MG-RAST and MGnify.
# Load the data in associative arrays.

# load the database_groups.tsv from the dictionary and filter microbes only
(ARGIND==1 && $1==-2 && ($4 in microbe_taxa)){

    microbes[$2]=$4

}
(ARGIND==2 && $1 == -2){

    if ($2 in microbes) {
        

# these are arrays of arrays, one for each source of the variable $5 
# e.g MGnify, MG-RAST
        if ($3 == -27){

            taxa_env[$5][$2" "$4]++;
            env[$5][$4]++;
            taxa[$5][$2]=$0;

        }
        else if ($3 == -21){
            
            taxa_proc[$5][$2" "$4]++;
            proc[$5][$4]++;
            taxa[$5][$2]=$0;

        }
    }
}
# Load the second file, NCBI taxonomy dump file with NCBI Ids and ranks.
(ARGIND==3){
    
    rank[$1]=$5;
    
}
#print statistics for each source.
END{ 

    print "source" "\t" "Unique taxa" "\t" "Unique environments" \
             "\t" "Unique processes" "\t" "Taxa associations with Environments"\
             "\t" "Taxa associations with processes" "\t" "Total interactions";

    print "microbes" "\t" length(microbes)
    
    for (i in taxa){

        print i "\t" length(taxa[i]) "\t" length(env[i]) "\t" length(proc[i])\
                 "\t" length(taxa_env[i]) "\t" length(taxa_proc[i]) "\t" \
                 length(taxa_proc[i])+length(taxa_env[i]) "\n";

        for (j in taxa[i]){

             taxa_rank[rank[j]]++
             taxonomy[microbes[j]]++

            }

        for (e in taxa_env[i]){

            print e "\t" i "\t" taxa_env[i][e]

            }

        for (p in taxa_proc[i]){

            print p "\t" i "\t" taxa_proc[i][p]

            }

        for (r in taxa_rank){

            print r "\t" taxa_rank[r]

            }
        for (m in taxonomy){

            print m "\t" taxonomy[m]
        }
    
    }
}

