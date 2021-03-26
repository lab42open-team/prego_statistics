#! /usr/bin/gawk -f
# how to run
# ./textmining_statistics.awk /data/textmining/database_pairs.tsv
BEGIN {
    FS="\t"
    # Field names
    type_1=1; id_1=2; type_2=3; id_2=4; z_score=5; score=6

    }
## to do: create an array with  $taxa[$id_1]==$0 and then split the elements. Then for the different 

($type_1 == -2){$taxa[$id_1]=$0};
($type_1 == -2 && $type_2 == -27){$taxa_env[$id_2]++}
($type_1 == -2 && $type_2 == -21){$taxa_proc[$id_2]++}


END{print "Unique taxa" "\t" length(taxa)  "\n" "Unique environments" "\t" length(taxa_env) "\n" "Unique processes" "\t" length(taxa_proc)}

#for (i in taxa_env) {count_env[taxa_env[i]]++}; print "Total taxa_env" "\t" count_env }
