#!/usr/bin/R/Rscript

library(tidyverse)
library(ggbreak)


data_path  <- "/data/databases/scripts/prego_statistics/"
ranks_file <- paste(data_path, "ranks_all_channels.tsv", sep="")

ranks     <- read.delim(ranks_file, header=TRUE, sep="\t") %>% filter(phylum_name != "") %>% mutate(phylum_name = as.character(phylum_name))


ranks_all <- ranks %>% filter(file=="all", superkingdom != "no rank", type != "-25", type != "-26")
ranks_tm  <- ranks %>% filter(file=="/data/textmining/database_pairs.tsv" , superkingdom != "no rank", type != "-25", type != "-26")
ranks_exp <- ranks %>% filter(file=="/data/experiments/database_pairs.tsv", superkingdom != "no rank", type != "-25", type != "-26")
ranks_kn  <- ranks %>% filter(file=="/data/knowledge/database_pairs.tsv"  , superkingdom != "no rank", type != "-25", type != "-26")


# Make a function to plot for all cases
ggfun <- function(input_df, start, end){

    p <- ggplot(input_df, aes(x = no_entities, y = reorder(phylum_name, -no_entities), fill = as.character(type))) +
            geom_col(position="dodge") +
            #scale_fill_discrete(name = "Entity types",
            #                    labels = c("Organisms", "Biological Processes",
            #                                "Molecular Functions", "Environments")) +
            xlab("Number of unique entities") +
            ylab("Phyla")+
            scale_x_break(c(start, end), scales = 0.2)+
            theme_bw()+
            scale_fill_manual(name = "Entity types",
                              labels = c("Organisms", "Biological Processes", 
                                         "Molecular Functions", "Environments"),
                              values=c("-2"="#1d2758",
                                       "-21"="#c81976",
                                       "-23"="#e66101",
                                       "-27"="#8793AB"))+
            theme(legend.position="bottom",
                  legend.title = element_text(size = 12),
                  legend.text  = element_text(size = 10),
                  axis.text    = element_text(size =  5),
                  axis.text.x  = element_text(angle = 45, hjust = 1)
                  ) +
            guides(fill=guide_legend(nrow=2, byrow=TRUE))

    q <- p + facet_grid(rows = vars(superkingdom), scales="free", space = "free")

    return(q)
}


a = ggfun(ranks_all, 25000, 250000)
ggsave("all_channels_ranks.png", plot=a, width = 15, height = 44, units = "cm", device="png")

b = ggfun(ranks_tm, 25000, 250000)
ggsave("textmining_ranks.png", plot=b, width = 15, height = 44, units = "cm", device="png")

ci = ggfun(ranks_exp, 3900, 3901)
ggsave("experiments_ranks.png", plot=ci, width = 15, height = 24, units = "cm", device="png")

di = ggfun(ranks_kn, 4000, 6000)
ggsave("knowledge_ranks.png", plot=di, width = 15, height = 44, units = "cm", device="png")
#

