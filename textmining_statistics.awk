#! /usr/bin/gawk -f

BEGIN {
    FS="\t"

    }

{times[$1]++}
END{print length(times) }

#cd /data/databases/pubmed
#ls -1 | awk '{sub(/\./," ")}1' | awk '{gsub(/_stats/,"",$1); print $2}' | sort | uniq -c

#more pubmed_ids.tsv | gawk '!seen[$0]++' | wc -l 
