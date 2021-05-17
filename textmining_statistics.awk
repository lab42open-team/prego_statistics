#! /usr/bin/gawk -f
# how to run
# ./textmining_statistics.awk /data/textmining/database_pairs.tsv
BEGIN {
    FS="\t"
    # Field names initialization for better readability
    type_1=1; id_1=2; type_2=3; id_2=4; z_score=5; score=6

    }

# load only organisms interactions (that is half the file)
($type_1 == -2){

    taxa[$id_1]=$0

    # count the taxa - environments associations
    if ($type_2 == -27){
        
        taxa_env[$id_1" "$id_2]++;
        env[$id_2]++;

    }
    # count the taxa - processes associations
    else if ($type_2 == -21){

        proc[$id_2]++;
        taxa_proc[$id_1" "$id_2]++;
    }
}

END{print "Unique taxa" "\t" length(taxa)  "\n" "Unique environments" "\t" length(env) "\n" "Unique processes" "\t" length(proc) "\n" "Taxa associations with Environments" "\t" length(taxa_env) "\n" "Taxa associations with processes" "\t" length(taxa_proc) "\n" "Total interactions" "\t" length(taxa_proc)+length(taxa_env) }

