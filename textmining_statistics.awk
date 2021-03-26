#! /usr/bin/gawk -f
# how to run
# gunzip -c /data/databases/pubmed/pubmed*.tsv.gz | ./pubmed_statistics.awk
BEGIN {
    FS="\t"
    # Field names
    id=1; authors=2; journal=3 ; year=4 ;titles=5; abstract=6

    }

{times[$1]++}
END{print "Unique abstracts" "\t" length(times); for (i in times){sum+=times[i]}; print "Total abstracts" "\t" sum }

#cd /data/databases/pubmed
#ls -1 | awk '{sub(/\./," ")}1' | awk '{gsub(/_stats/,"",$1); print $2}' | sort | uniq -c

#more pubmed_ids.tsv | gawk '!seen[$0]++' | wc -l 
