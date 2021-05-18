#! /usr/bin/gawk -f

########################################################################################
# script name: knowledge_statistics.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: PREGO - WP4
########################################################################################
# GOAL:
# Aim of this script is to calculate the contents of the associations pairs derived from
# different sources of JGI IMG and BioProject from the KNOWLEDGE channel
# in terms of NCBI ids, ENVO ids, GO ids and their assotiations. Also the contents
# taxominic rank
# NOTE: this script is for ALL associations regardless their score!!!
########################################################################################
#
# usage: ./knowledge_statistics.awk /data/knowledge/database_pairs.tsv nodes.dmp
#
############################################################################################

BEGIN {
    FS="\t"
    # Field names for readability
    type_1=1; id_1=2; type_2=3; id_2=4; source=5; evidence=6; score=7; explicit=8; url=9

    }
# Load the first input file, the associations. And filter the taxa (-2) to process the taxa interactions with environments (-27) and processes (-21)
# there are 2 sources of Knowledge: BioProject and JGI IMG.
# Load the data in associative arrays.

(NR==FNR && $type_1 == -2){

    if ($source=="BioProject"){
        
        taxa[$source][$id_1]=$0

        if ($type_2 == -27){

            taxa_env[$source][$id_1" "$id_2]++;
            env[$source][$id_2]++;

        }
        else if ($type_2 == -21){
            
            taxa_proc[$source][$id_1" "$id_2]++;
            proc[$source][$id_2]++;

        }
    }

    else if ($source=="JGI IMG"){
        
        taxa[$source][$id_1]=$0

        if ($type_2 == -27){

            taxa_env[$source][$id_1" "$id_2]++;
            env[$source][$id_2]++;

        }
        else if ($type_2 == -21){
            
            taxa_proc[$source][$id_1" "$id_2]++;
            proc[$source][$id_2]++;

        }
    }
}
# Load the second file, NCBI taxonomy dump file with NCBI Ids and ranks.
{
    rank[$1]=$5;
}
END{ 

    print "source" "\t" "Unique taxa" "\t" "Unique environments" "\t" "Unique processes"  "\t" "Taxa associations with Environments" "\t" "Taxa associations with processes" "\t" "Total interactions";

    for (i in taxa){

        print i "\t" length(taxa[i]) "\t" length(env[i]) "\t" length(proc[i]) "\t" length(taxa_env[i]) "\t" length(taxa_proc[i]) "\t" length(taxa_proc[i])+length(taxa_env[i]) "\n";

        for (j in taxa[i]){

             taxa_rank[rank[j]]++
            }

        for (r in taxa_rank){

            print r "\t" taxa_rank[r]

            }
    
        }
}
