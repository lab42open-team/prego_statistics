# PREGO data descriptives

* how many taxa at a specific taxonomic level?
* how many samples for MGnify?
* how many samples from MG-RAST?
* how many annotated genomes from JGI?
* how many processes?
* how many envinronments?
* how many interactions (in total, taxon-process, taxon-environmets)?

## How to run the scripts

### Total

```
cat /data/knowledge/database_pairs.tsv /data/knowledge/jgi_isolates_associations.tsv /data/textmining/database_pairs.tsv  /data/experiments/mgrast_wgs_associations.tsv /data/experiments/mgrast_markergene_associations.tsv /data/experiments/database_pairs.tsv /data/experiments/mgnify_markergene_associations.tsv | gawk -F"\t" '{gsub(/NCBI_ID:/,""); print}' | gawk -F"\t" '{gsub(/JGI\/IMG/,"JGI IMG"); print}' | ./total_statistics.awk /data/dictionary/database_groups.tsv nodes.dmp - > statistics_all.tsv
```

### Text mining

```
./textmining_statistics.awk /data/dictionary/database_groups.tsv nodes.dmp /data/textmining/database_pairs.tsv > statistics_textmining.tsv
```

### Experiments
```
cat /data/experiments/mgrast_wgs_associations.tsv /data/experiments/mgrast_markergene_associations.tsv /data/experiments/database_pairs.tsv /data/experiments/mgnify_markergene_associations.tsv | gawk -F"\t" '{gsub(/NCBI_ID:/,""); print}' | ./experiments_statistics.awk /data/dictionary/database_groups.tsv nodes.dmp - > statistics_experiments_all.tsv
```

### Knowledge


```
cat /data/knowledge/database_pairs.tsv /data/knowledge/jgi_isolates_associations.tsv | gawk -F"\t" '{gsub(/NCBI_ID:/,""); print}' | gawk -F"\t" '{gsub(/JGI\/IMG/,"JGI IMG"
); print}' | ./knowledge_statistics.awk /data/dictionary/database_groups.tsv nodes.dmp - > statistics_knowledge_all.tsv
```

## Text mining

Text mining is performed on PUbMed abstracts with the PREGO dictionary.

### PubMed abstracts

The `pubmed_statistics.awk` script summarises some info of the PubMed tsv files.

```
date ; gunzip -c /data/databases/pubmed/pubmed*.tsv.gz | ./pubmed_statistics.awk ; dat
e
```

PubMed tsv files contain 6 fields. There are case that some of these are empty or even duplicated. The above script finds these inconcistencies and calculates the number of abstracts.

Fields:
PMID|DOI        Authors     Journal.volume:pages        year        title       Abstract

Questions:
* how many abstracts?
* how many unique abstracts
* how many no-empty PMIDs

### How to run

### Organisms - Environments interactions

### Organisms - Processes interactions


## Experiments

How to run.

### Mgnify data structure and statistics

This document aims to complement the R script for the plots and statistics of Mgnify data.

Mgnifymarker gene data have a layered structure of studies, samples and runs/experiments. Each study has multiple samples and each sample can have multiple runs. All this data are stored in JSON files as downloaded from the API to our **oxygen** server. The basic unit for our species data is **samples**. This means that for each sample the *extract_mgnify_markergene_associations.py* script summarizes the organisms found in this sample with the metadata describing them. Metadata are extracted from the tagger executed in the samples metadata and they contain term ids from ENVO (type -27), BTO tissues (type -25), GO biological process (type -21) and host organism (type -2).

Samples are the connecting element of species with their metadata. This makes **samples** the *currency* of all the distributions that arise, thereby everything is being counted in terms of samples abundance. Hence there are 3 levels of information : samples associated with species, samples associated with metadata and samples that metadata and species co-occur. Not all samples have species and not all samples have metadata, hence the **background** distributions are different for metadata and species in terms of samples.

#### Definitions

The **background** of each NCBI id is the number of samples it appears. Respectively, the **background** of each metadatum term is the abundance of samples it has been found. **Evidence**, on the other hand, refers to a specific association of a NCBI id with a specific metadatum term id. More specifically, **evidence** is the abundance of samples that these specific terms co-occur. Using terminology from set theory, evidence is the *intersection* of samples of NCBI ids with the samples with metadata ids.

#### Distributions

We downloaded ~60000 samples from MGnify which contain 3391 NCBI ids. From these ids the 1081 belong to genera and the 1790 belong to species. Regarding metadata, the tagger assigned 442 different terms to samples. Using samples as the medium, we found 365997 associations of NCBI ids with metadata. From these associations, the ~130000 are species-level and more specifically the 124583 are bacterial.

#### Sample size in terms of NCBI ids and metadata ids

The size of samples with NCBI ids spans 3 orders of magnitude. There is a peak of 390 samples with 94 NCBI ids. Fifty percent of the samples have less than 500 NCBI ids.

#### Association score

The score of Lars for MGnify uses the background of terms to normalize the intersection of the associations. The plot of the number of associations against the score value shows a very dense area until score=5 (mean=4.5, median=2.5 and 3rd quantile=5.2) with a maximum of ~100. Also in cases where the background of metadata is 1 the score is 2 which is very high. Statistically it would be preferable to spread the score distribution across it's range of values, reduce oversampling and undersampling biases.

For these reasons we implemented a different score, mutual information (MI). MI is a measure of the dependence between the two random variables and is insensitive to the size of the data sets. In addition, MI is zero if and only if the two random variables are strictly independent (Mutual Information between Discrete and Continuous Data Sets).


The distribution of MI is more spread across associations compared with the previous score.
Is it more relevant? This is the next thing to explore.

### MG-RAST

## Knowledge

### JGI
