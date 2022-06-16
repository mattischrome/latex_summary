# 03-aaa-with-rag.r

# Packages
library(tidyverse)
library(hrbrthemes)
library(fingertipsR)
library(ggthemes)
library(ggtext)


### MY VARIABLES
XXXX <- 
  YYYY <- ""
ZZZZ <- ""


# Configure location for source files
source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images/'

# Fingertips-y stuff
inds <- indicators()
##inds_aaa <- inds[grep('cancer screening',inds$IndicatorName),]

aaa_indicator <- XXXX

# NB 92317 value is percentage of males over 65 - need to check that this is the desired target of screening
# Looks OK: https://fingertips.phe.org.uk/covid19#page/6/gid/1938133361/pat/15/par/E92000001/ati/6/are/E12000004/iid/92317/age/94/sex/1/cat/-1/ctp/-1/cid/4/tbm/1/page-options/car-do-0


# df <- fingertips_data(IndicatorID = aaa_indicator, AreaTypeID = 101)
areas_of_interest <- c('England', 'South East region', 'West Sussex')
areas_of_interest_w_ds_and_bs <- c(areas_of_interest, 'Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing')

df_to_plot <- fingertips_data(IndicatorID = aaa_indicator, AreaTypeID = 102) %>% 
  filter(AreaName %in% areas_of_interest)

df_to_plot_ds_and_bs <- fingertips_data(IndicatorID = aaa_indicator, AreaTypeID = 101) %>% 
  filter(AreaName %in% areas_of_interest_w_ds_and_bs)

# We use AreaTypeID = 102 to get upper tier local authorities e.g. West Sussex and its CIPFA neighbours
# But we also need lower tier local authorities (Adur, Arun, etc) - this is AreaTypeID = 101

# For more information on areas in the Fingertips, run this code
# areas <- area_types()
# View(areas)

# Let's bind together the data sets we have
# NB we only need West Sussex from the UTLA data this time around

df_plot_all <-rbind(df_to_plot %>% filter(AreaName == 'West Sussex'), df_to_plot_ds_and_bs)

#  Plot 1 is a bar chart comparing West Sussex and LTLAs to the England rate

# This outputs all the possible values in this column
# (df_plot_all$ComparedtoEnglandvalueorpercentiles %>% unique)
rag_colours <- c('Better' ='green','Similar'='orange','Not compared'='gray','Worse'='red')

# An added complication in this plot is that we need England, South East and West Sussex up top, and then the LTLAs in order of their rates
# Nice to have: skip a bar between these values and the LTLAs - not working at the moment, might revisit at some point possibly with facets
# Another variation is fixed order for LTLAs as well

# FYI This is a helpful blog post on all things bar chart: https://www.cedricscherer.com/2021/07/05/a-quick-how-to-on-labelling-bar-graphs-in-ggplot2/

bar_df <- df_plot_all %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>% 
  arrange(-Value) %>% 
  mutate(AreaName = forcats::fct_rev(forcats::fct_inorder(AreaName)),
         AreaName = forcats::fct_relevel(AreaName, rev(areas_of_interest), after = Inf))

rag_bar_chart <- ggplot(
  data = bar_df,
  mapping = aes(x = Value, y = AreaName, fill = ComparedtoEnglandvalueorpercentiles)) +
  geom_bar(stat = 'identity')+
  scale_fill_manual(values = rag_colours)+
  theme_wsj() +
  scale_color_ft() +
  theme(legend.position = 'none',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(x = 'YYYY')

print(rag_bar_chart)

ggsave(rag_bar_chart, filename = paste0(ZZZZ,".png"), path = save_place, bg = 'transparent', units = 'mm', width = 180, height = 180)
