#! /usr/bin/gawk -f
# how to run
# ./knowledge_statistics.awk /data/knowledge/database_pairs.tsv
BEGIN {
    FS="\t"
    # Field names
    type_1=1; id_1=2; type_2=3; id_2=4; source=5; evidence=6; score=7; explicit=8; url=9

    }
## to do: create an array with  $taxa[$id_1]==$0 and then split the elements. Then for the different 
(NR==FNR && $type_1 == -2){

    if ($source=="BioProject"){
        
        taxa[$source][$id_1]=$0

        if ($type_2 == -27){
            taxa_env[$source][$id_2]++
        }
        else if ($type_2 == -21){
            taxa_proc[$source][$id_2]++
        }
    }

    else if ($source=="JGI IMG"){
        
        taxa[$source][$id_1]=$0
        
        if ($type_2 == -27){
            taxa_env[$source][$id_2]++
        }
        
        else if ($type_2 == -21){
            taxa_proc[$source][$id_2]++
        }
    }
}
#print mgrast and mgnify
END{ 

    print "source" "\t" "Unique taxa" "\t" "Unique environments" "\t" "Unique processes";

    for (i in taxa){

    print i "\t" length(taxa[i]) "\t" length(taxa_env[i]) "\t" length(taxa_proc[i]) "\n"
    
    }

}

#for (i in taxa_env) {count_env[taxa_env[i]]++}; print "Total taxa_env" "\t" count_env }
