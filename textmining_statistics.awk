#! /usr/bin/gawk -f

BEGIN {print "test"}
#cd /data/databases/pubmed
#ls -1 | awk '{sub(/\./," ")}1' | awk '{gsub(/_stats/,"",$1); print $2}' | sort | uniq -c
