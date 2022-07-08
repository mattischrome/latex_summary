# 01-overall.r 
# Script generating figures for chapter 1 of the West Sussex JSNA summary

# Packages
library(tidyverse)
library(hrbrthemes)
library(fingertipsR)
library(ggthemes)
library(ggtext)

# Configure location for source files
# source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources'
source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images/'

# Fingertips-y stuff
inds <- indicators()
inds_le <- inds[grep('Cancer screening',inds$IndicatorName),]

# cancer screening coverage
le_indicator <- 93560

df <- fingertips_data(IndicatorID = le_indicator, AreaTypeID = 102)
areas_of_interest <- c('England', 'South East Region', 'West Sussex')


df_females <- df %>% 
  filter(Sex == 'Female') %>% 
  filter(AreaName %in% areas_of_interest)

indicator_timeperiod <- df_females$Timeperiod %>% unique() %>% sort()
indicator_timeperiod[seq(2,length(indicator_timeperiod),2)] <- ''

female_caption_data <- df_females %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>% 
  select(AreaName,Value,Timeperiod) %>% 
  mutate(Value = round(Value,1))

female_caption <- paste0('**',str_replace_all(string = female_caption_data[2,3], pattern = ' ', replacement = ''),' Cervical Cancer Screening Coverage**<br>',female_caption_data[2,1],' = ',female_caption_data[2,2],' years<br>',female_caption_data[1,1],' = ',female_caption_data[1,2],' years')
cerv_plot <- ggplot(
  data = df_females,
  mapping = aes(x = Timeperiod, y = Value, color = AreaName, group=AreaName))+
  geom_line(size=2) +
  geom_point(shape=21, size=3, fill = 'white', stroke = 3) +
  #geom_richtext(x='2011 - 13', y=88, label=female_caption, stat = 'unique', color = 'black', hjust=0, fill = NA, label.color = NA, size = rel(5)) +
  expand_limits(y = c(55, 80)) +
  scale_x_discrete(labels = indicator_timeperiod) +
  theme_wsj() +
  scale_color_ft() +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1), hjust=0, vjust=0))+
  labs(y='% Screening Coverage')

# cerv_plot

ggsave(cerv_plot, filename = 'cervical_cancer_screening.png', path = save_place, bg = 'transparent', units = 'mm', width = 235, height = 130)
