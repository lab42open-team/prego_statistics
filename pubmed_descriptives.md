PREGO contents
================
27 August, 2020

    library(tidyverse)

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✔ ggplot2 3.3.0     ✔ purrr   0.3.3
    ## ✔ tibble  3.0.0     ✔ dplyr   0.8.5
    ## ✔ tidyr   1.0.2     ✔ stringr 1.4.0
    ## ✔ readr   1.3.1     ✔ forcats 0.5.0

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

This script is for the Pubmed database
--------------------------------------

    cd /data/databases/pubmed
    ls -1 | awk '{sub(/\./," ")}1' | awk '{gsub(/_stats/,"",$1); print $2}' | sort | uniq -c

    ##     238 html
    ##    1252 tsv.gz
    ##       2 txt
    ##    1252 xml.gz
    ##    1252 xml.gz.md5

The unique abstracts of Pubmed are:

    more pubmed_ids.tsv | gawk '!seen[$0]++' | wc -l 

    ## 31263344
