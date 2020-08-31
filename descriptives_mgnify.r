#!/usr/bin/Rscript

library(tidyverse)
library(Rfast)
library(infotheo)
#library(vegan) #needs to installed globally
## file loading

mgnify_associations <- read_delim("/data/databases/scripts/gathering_data/mgnify/mgnify_markergene_associations.tsv", delim = "\t", col_names = F) %>% select(-10)
colnames(mgnify_associations) <- c("type_1","term_1","type_2","term_2","source","evidence","MI","status","url")

mgnify_sample_entity_sources <- read_delim("/data/databases/scripts/gathering_data/mgnify/sample_entity_sources.tsv", delim = "\t", col_names = F)
colnames(mgnify_sample_entity_sources) <- c("sample_id","type","term_id")

mgnify_taxon_sample <- read_delim("/data/databases/scripts/gathering_data/mgnify/taxon_sample_abundance.tsv", delim = "\t", col_names = F)
colnames(mgnify_taxon_sample) <- c("ncbi_id","sample_id")

all_samples <- as_tibble(unique(c(unique(mgnify_sample_entity_sources$sample_id),unique(mgnify_taxon_sample$sample_id))))
colnames(all_samples) <- "sample_id"
total_samples <-nrow(all_samples)

all_data <- all_samples %>% left_join(mgnify_sample_entity_sources,by=c("sample_id"="sample_id")) %>% left_join(mgnify_taxon_sample, by=c("sample_id"="sample_id"))

all_data_bipartite <- all_data %>% group_by(term_id,type,ncbi_id) %>% summarise(total_associations=n()) %>% mutate(associations_freq=total_associations/as.numeric(total_samples))

## Mgnify terms and the samples they are tagged summary 

mgnify_sample_entity_sources_samples <- mgnify_sample_entity_sources %>% group_by(type,sample_id) %>% summarise(total_terms=n()) # the tagger can assign multiple terms of a specific type (e.g multiple ENVO terms) 

mgnify_sample_entity_sources_summary <- mgnify_sample_entity_sources %>% group_by(type,term_id) %>% summarise(total_samples=n()) %>% group_by(type,total_samples) %>% summarize(total_terms=n())

mgnify_sample_entity_sources_summary_plot <- ggplot()+
  geom_point(data = mgnify_sample_entity_sources_summary, aes(x=total_samples,y=total_terms, colour=factor(type)))+
  ylab("Number of terms that have the same background size")+
  xlab("Number of Samples (background of terms)")+
  labs(colour="Types")+
  ggtitle("Mgnify terms and the samples they are tagged distribution")+
  theme_bw()

ggsave(filename = "plots/mgnify_sample_entity_sources_summary_plot.png",plot = mgnify_sample_entity_sources_summary_plot,device = "png")


mgnify_sample_entity_sources_summary_log_plot <- ggplot()+
  geom_point(data = mgnify_sample_entity_sources_summary, aes(x=total_terms,y=log2(total_samples), colour=factor(type)))+
  xlab("Number of terms")+
  ylab("log2 of Number of Samples")+
  labs(colour="Types")+
  ggtitle("Mgnify terms and the samples they are tagged distribution")+
  theme_bw()

ggsave(filename = "plots/mgnify_sample_entity_sources_summary_log_plot.png",plot = mgnify_sample_entity_sources_summary_log_plot,device = "png")


## Mgnify and all associations including their score. The original output file

### Score of Lars 
#summary(mgnify_associations$score)

#mgnify_associations_score_distribution <- mgnify_associations %>% group_by(score,type_2) %>% summarise(number_associations=n())
#
#mgnify_associations_score_distribution_plot <- ggplot()+
#  geom_point(data = mgnify_associations_score_distribution, aes(x=score, y=number_associations, colour=factor(type_2)))
#
#ggsave(filename = "plots/mgnify_associations_score_distribution_plot.png",plot = mgnify_associations_score_distribution_plot,device = "png")
#
#mgnify_associations_score_distribution_log_plot <- ggplot()+
#  geom_point(data = mgnify_associations_score_distribution, aes(x=score, y=log2(number_associations), colour=factor(type_2)))
#
#ggsave(filename = "plots/mgnify_associations_score_distribution_log_plot.png",plot = mgnify_associations_score_distribution_log_plot,device = "png")

### Evidence

### count term_1 samples for background_term_1

mgnify_taxon_sample_background_term_1 <- mgnify_taxon_sample  %>% group_by(ncbi_id) %>% summarise(background_term_1=n()) %>% mutate(background_term_1_freq=background_term_1/as.numeric(total_samples))


mgnify_sample_entity_sources_background_term_2 <- mgnify_sample_entity_sources %>% group_by(type,term_id) %>% summarise(background_term_2=n()) %>% mutate(ckground_term_2_freq=background_term_2/as.numeric(total_samples))

mgnify_associations_evidence <- mgnify_associations %>% extract(evidence, c("samples", "background_term_2"), "([[:digit:]]+) of ([[:digit:]]+)*.") %>% left_join(mgnify_taxon_sample_background_term_1, by=c("term_1"="ncbi_id")) #%>% left_join(ncbi_tax_rank, by=c("term_1"="ncbi_id")) %>% left_join(ncbi_species_kingdom, by=c("term_1"="ncbi_id"))
#
mgnify_associations_evidence$samples <- as.numeric(mgnify_associations_evidence$samples)
mgnify_associations_evidence$background_term_2 <- as.numeric(mgnify_associations_evidence$background_term_2)

### backgrounds are not correlated
cor(mgnify_associations_evidence$background_term_1,mgnify_associations_evidence$background_term_2)
### score summary







mgnify_associations_evidence_summary <- mgnify_associations_evidence %>% group_by(type_2,background_term_2) %>% summarise(count_associations=n()) #%>% group_by(type_2,count_samples) %>% summarise(count_background=n())

### find the pearson correlation of the number of associations with the size of the background of the NCBI ids. The correlation is executed for each association type seperately.

mgnify_associations_evidence_summary_plot <- ggplot()+
  geom_point(data = mgnify_associations_evidence_summary, aes(x=background_term_2, y=count_associations, colour=factor(type_2)))

ggsave(filename = "plots/mgnify_associations_evidence_summary_plot_term_2.png",plot = mgnify_associations_evidence_summary_plot,device = "png")


mgnify_associations_evidence_summary_plot <- ggplot()+
  geom_point(data = mgnify_associations_evidence_summary, aes(x=background_term_2, y=count_associations, colour=factor(type_2)))+
  scale_x_continuous(limits=c(0,1000),breaks=seq(0,5000,100))
ggsave(filename = "plots/mgnify_associations_evidence_summary_plot_term_2_x_limits.png",plot = mgnify_associations_evidence_summary_plot,device = "png")

mgnify_associations_evidence_summary_term_1 <- mgnify_associations_evidence %>% group_by(type_2,background_term_1) %>% summarise(count_associations=n()) #%>% group_by(type_2,count_samples) %>% summarise(count_background=n())

mgnify_associations_evidence_summary_plot_term_1 <- ggplot()+
  geom_point(data = mgnify_associations_evidence_summary_term_1, aes(x=background_term_1, y=count_associations, colour=factor(type_2)))

ggsave(filename = "plots/mgnify_associations_evidence_summary_plot_term_1.png",plot = mgnify_associations_evidence_summary_plot_term_1,device = "png")


mgnify_associations_evidence_summary_term_1 %>% group_by(type_2) %>% group_modify(~ tibble(cor(.x$background_term_1,.x$count_associations)))
### background terms scatter plot

mgnify_associations_evidence_backgrounds_plot <- ggplot()+
  geom_point(data = mgnify_associations_evidence,aes(x=background_term_1,y = background_term_2,colour=factor(type_2)))
ggsave(filename = "plots/mgnify_associations_evidence_backgrounds_plot.png",plot = mgnify_associations_evidence_backgrounds_plot,device = "png")

### Jaccard index as association Score

mgnify_associations_evidence <- mgnify_associations_evidence %>% mutate(jaccard=samples/(background_term_2+background_term_1-samples))

mgnify_associations_evidence_jaccard_summary <- mgnify_associations_evidence %>% group_by(jaccard,type_2) %>% summarise(count_associations=n())

mgnify_associations_evidence_jaccard_summary_plot <- ggplot()+
  geom_point(data = mgnify_associations_evidence_jaccard_summary, aes(x=jaccard, y=count_associations, colour=factor(type_2)))+
  theme_bw()
ggsave(filename = "plots/mgnify_associations_evidence_jaccard_summary_plot.png",plot = mgnify_associations_evidence_jaccard_summary_plot,device = "png")

### Mutual Information

total_count_metadata_entries <- mgnify_sample_entity_sources %>% group_by(type,sample_id) %>% summarise(total_terms=n()) %>% group_by(type) %>% summarise(total_samples=n())

total_count_samples_with_ncbi_ids <- length(unique(mgnify_taxon_sample$sample_id))

mgnify_associations_evidence_MI_summary <- mgnify_associations_evidence %>% group_by(MI,type_2) %>% summarise(count_associations=n())

mgnify_associations_evidence_MI_plot <- ggplot()+
  geom_point(data = mgnify_associations_evidence_MI_summary, aes(x=MI,y=count_associations, colour=factor(type_2)))+
  theme_bw()
ggsave(filename = "plots/mgnify_associations_evidence_MI_plot.png",plot = mgnify_associations_evidence_MI_plot,device = "png")

## check which samples don't have NCBI ID
samples_without_ncbi_ids <- mgnify_sample_entity_sources %>% distinct(sample_id) %>% filter(!(sample_id %in% unique(mgnify_taxon_sample$sample_id)))

samples_without_metadata <- mgnify_taxon_sample %>% distinct(sample_id) %>% filter(!(sample_id %in% unique(mgnify_sample_entity_sources$sample_id)))
colnames(mgnify_sample_entity_sources) <- c("sample_id","type","term_id")


### Empirical Mutual Information calculation

mgnify_associations_evidence <- mgnify_associations_evidence %>% mutate(joint=samples/total_samples) %>% mutate(random=(background_term_1/total_samples)*(background_term_2/total_samples)) %>% mutate(mutual_info=joint*log(joint/random)) %>% mutate(PMI=log(joint/random)) %>% mutate(norm_MI=(MI/max(MI))*100)

mgnify_associations_evidence_norm_MI_plot <- mgnify_associations_evidence %>% group_by(norm_MI, type_2) %>% summarise(count_associations=n()) %>% ggplot() +
  geom_point(aes(x=norm_MI, y=count_associations, colour=factor(type_2)))+
  theme_bw()
ggsave(filename = "plots/mgnify_associations_evidence_norm_MI_summary_plot.png",plot = mgnify_associations_evidence_norm_MI_plot,device = "png")

mgnify_associations_evidence_mutual_info_summary <- mgnify_associations_evidence %>% group_by(mutual_info,type_2) %>% summarise(count_associations=n())

mgnify_associations_evidence_mutual_mutual_info_summary_plot <- ggplot()+
  geom_point(data = mgnify_associations_evidence_mutual_info_summary, aes(x=mutual_info, y=count_associations, colour=factor(type_2)))+
  theme_bw()
ggsave(filename = "plots/mgnify_associations_evidence_mutual_mutual_info_summary_plot.png",plot = mgnify_associations_evidence_mutual_mutual_info_summary_plot,device = "png")

### Pointwise mutual information

mgnify_associations_evidence_PMI_plot <- mgnify_associations_evidence %>% group_by(PMI, type_2) %>% summarise(count_associations=n()) %>% ggplot() +
  geom_point(aes(x=PMI, y=count_associations, colour=factor(type_2)))+
  theme_bw()
ggsave(filename = "plots/mgnify_associations_evidence_PMI_plot.png",plot = mgnify_associations_evidence_PMI_plot,device = "png")
