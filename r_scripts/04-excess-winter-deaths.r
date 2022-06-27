library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/JSNA/latex_summary/images/'

# Import EWD data since 1992
# This is in a funny format, which I've already had to clean up a bit before R

ewd_data_ons <- read_csv(paste0(source_place,"wsx_ewd.csv"))

# Like OHID, we exclude Covid-19 from the excess winter deaths index
# Did this at the command line because it was easier

# Pivot wider so one row per year

ewd_data <- ewd_data_ons %>%
  pivot_wider(names_from = Statistic, values_from = Value) %>% 
  mutate(mean = mean(Number),
         sd = sd(Number),
         upper_outer = mean+3*sd,
         upper_inner = mean+2*sd,
         lower_inner = mean-2*sd,
         lower_outer = mean-3*sd)

