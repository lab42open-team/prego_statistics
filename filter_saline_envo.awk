#! /usr/bin/gawk -f
###############################################################################
# script name: filter_saline_envo.awk
# path on oxygen: ?
# developed by: Savvas Paragkamian
# framework: ARENA 3D web
###############################################################################
# GOAL:
# This script creates a tsv file with all the associations of the supplied 
# ENVO terms.
###############################################################################
# How to run
# ./filter_saline_envo.awk database_pairs.tsv > prego_saline_envo.tsv
# 
# execution time in the whole knowledge base took 15 minutes
###############################################################################


BEGIN{

    FS="\t"

    envo["ENVO:00000017"]=1
    envo["ENVO:00000019"]=1
    envo["ENVO:00000054"]=1
    envo["ENVO:00000055"]=1
    envo["ENVO:00000226"]=1
    envo["ENVO:00000240"]=1
    envo["ENVO:00000279"]=1
    envo["ENVO:00002010"]=1
    envo["ENVO:00002012"]=1
    envo["ENVO:00002121"]=1
    envo["ENVO:00002197"]=1
    envo["ENVO:00002209"]=1
    envo["ENVO:00005775"]=1
    envo["ENVO:01000022"]=1
    envo["ENVO:01000307"]=1
    envo["ENVO:00002252"]=1
    envo["ENVO:00002255"]=1
    envo["ENVO:00000369"]=1
    envo["ENVO:00003044"]=1

}
(ARGIND==1) {

    #initiate an array with the desired NCBI ids to include only microbes.
    unicellular_taxa[$2]=1

}
(ARGIND>1 && ($2 in envo)){

    channel = gensub(/\/(.+)\/(.+)\/(.+)/,"\\2","g" ,FILENAME)

    if ($3==-2){
        if ($4 in unicellular_taxa){
            print channel FS $0
        }
    }
    else {
        print channel FS $0
    }
}
