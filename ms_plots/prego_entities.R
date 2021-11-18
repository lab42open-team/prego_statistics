#!/usr/bin/R/Rscript

library(tidyverse)

data_path  <- "/data/databases/scripts/prego_statistics/"
ranks_file <- paste(data_path, "ranks.tsv", sep="")

ranks     <- read.delim(ranks_file, header=TRUE, sep="\t")

ranks_all <- ranks %>% filter(file=="all", superkingdom != "no rank", type != "-25")
ranks_tm  <- ranks %>% filter(file=="textmining", superkingdom != "no rank", type != "-25")
ranks_exp <- ranks %>% filter(file=="/data/experiments/database_pairs.tsv", superkingdom != "no rank", type != "-25")
ranks_kn  <- ranks %>% filter(file=="knowledge", superkingdom != "no rank", type != "-25")

# Make a function to plot for all cases
ggfun <- function(input_df, output_name){

    p <- ggplot(input_df, aes(x = no_entities, y = phylum_name, fill = as.character(type))) +
            geom_bar(stat="identity", position="dodge") +
            scale_fill_discrete(name = "Entity types",
                                labels = c("Organisms", "Biological Processes",
                                            "Molecular Functions", "Environments")) +
            xlab("Number of unique entities") +
            ylab("Phyla")+
            theme(legend.position="bottom",
                  legend.title = element_text(size=12),
                  legend.text = element_text(size=10)) +
            guides(fill=guide_legend(nrow=2, byrow=TRUE))

    a <- p + facet_grid(rows = vars(superkingdom), scales="free", space = "free")

    ggsave(output_name, plot=q, width = 15, height = 24, units = "cm", device="png")
}


ggfun(ranks_all, "all_ranks.png")
ggfun(ranks_tm,  "textmining_ranks.png")
ggfun(ranks_exp, "experiments_ranks.png")
ggfun(ranks_kn,  "knowledge_ranks.png")



