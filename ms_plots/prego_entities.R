#!/usr/bin/R/Rscript

library(tidyverse)
library(ggbreak)   #
library(grid)      # to enable unit.pmax()
library(ggpubr)    # to enable ggarrange()
library(gridExtra) # to enabel grid.arrange()
library("scales")  # to enable comma_format()


data_path  <- "/data/databases/scripts/prego_statistics/"
ranks_file <- paste(data_path, "ranks_all_channels.tsv", sep="")

ranks     <- read.delim(ranks_file, header=TRUE, sep="\t") %>% filter(phylum_name != "") %>% mutate(phylum_name = as.character(phylum_name))


ranks_all <- ranks %>% filter(file=="all", superkingdom != "no rank", type != "-25", type != "-26")
ranks_tm  <- ranks %>% filter(file=="/data/textmining/database_pairs.tsv" , superkingdom != "no rank", type != "-25", type != "-26")
ranks_exp <- ranks %>% filter(file=="/data/experiments/database_pairs.tsv", superkingdom != "no rank", type != "-25", type != "-26")
ranks_kn  <- ranks %>% filter(file=="/data/knowledge/database_pairs.tsv"  , superkingdom != "no rank", type != "-25", type != "-26")


# Make a function to plot for all cases
plotFun <- function(input_df, start, end){


    domain <- as.character(unique(input_df$superkingdom))
    print(domain)
    p <- ggplot(input_df
                ) +
            geom_col(
                     position="dodge",
                aes(x    = no_entities,
                    y    = reorder(phylum_name, -no_entities),
                    fill = as.character(type)
                    )
                     ) +
            ggtitle(domain)+
            #scale_x_break(c(start, end), scales = 0.2) +
            scale_fill_manual(name = "Entity types",
                              labels = c("Organisms", "Biological Processes",
                                         "Molecular Functions", "Environments"),
                              values=c("-2"="#1d2758",
                                       "-21"="#c81976",
                                       "-23"="#e66101",
                                       "-27"="#8793Af")
                              )+
            scale_x_continuous(trans  = 'log10', 
                               name   = "Number of entities",
                               n.breaks = 4,
                               labels = label_comma()
                               #label_number()
                               )+
            theme_bw() +
            theme(
                  axis.text    = element_text(size =  5),
                  axis.text.x  = element_text(angle = 45, hjust = 1),
                  axis.title.y = element_blank(),
                  axis.text.y  = element_text(size = 6),
                  legend.position = "none",
                  plot.title      = element_text(vjust = -6, hjust = 1.0)
                  )
    return(p)
}


a_1 = plotFun(ranks_all %>% filter(superkingdom=="bacteria"), 25000, 250000)
ggsave("test_bacteria.png", plot = a_1, width = 21, height = 30, units = "cm", dpi = 300, device = "png")

a_2 = plotFun(ranks_all %>% filter(superkingdom=="archaea"), 25000, 250000)
ggsave("test_archaea.png", plot = a_2, width = 21, height = 30, units = "cm", dpi = 300, device = "png")

a_3 = plotFun(ranks_all %>% filter(superkingdom=="eukaryotes"), 25000, 250000)
ggsave("test_eukaryotes.png", plot = a_3, width = 21, height = 30, units = "cm", dpi = 300, device = "png")

a_3 <- a_3 + theme(legend.position = "bottom",
                  legend.title    = element_text(size = 12),
                  legend.text     = element_text(size = 10),
                  )+
            guides(fill = 
                   guide_legend(
                                nrow = 2,
                                byrow = TRUE,
                                title.position = "top"
                   )
            )


layout <- rbind(
                c(1,2),
                c(1,3)
                )

final <- grid.arrange(
                      a_1, a_2, a_3,
                      layout_matrix = layout
                   )

ggsave("all_channels_ranks.png", plot=final, width = 21, height = 30, units = "cm",dpi = 300, device="png")

#b = plotFun(ranks_tm, 25000, 250000)
#ggsave("textmining_ranks.png", plot=b, width = 15, height = 44, units = "cm", dpi = 300, device="png")
#
#ci = plotFun(ranks_exp, 3900, 3901)
#ggsave("experiments_ranks.png", plot=ci, width = 15, height = 24, units = "cm", dpi = 300, device="png")
#
#di = plotFun(ranks_kn, 4000, 6000)
#ggsave("knowledge_ranks.png", plot=di, width = 15, height = 44, units = "cm", dpi = 300, device="png")
##
#
