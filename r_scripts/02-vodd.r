# visually obvious dental decay in 5 year-olds over time

# Packages
library(tidyverse)
library(hrbrthemes)
library(fingertipsR)
library(ggthemes)
library(ggtext)

# Configure location for source files
source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images'

# Fingertips-y stuff
inds <- indicators()
inds_vodd <- inds[grep('dental',inds$IndicatorName),]

vodd_indicator<- 93563

df <- fingertips_data(IndicatorID = vodd_indicator, AreaTypeID = 102)
areas_of_interest <- c('England', 'South East region', 'West Sussex')

df_plot <- df %>% 
  filter(AreaName %in% areas_of_interest) %>% 
  mutate(AreaNamePlot = ifelse(AreaName == 'South East region', 'South East', AreaName))

area_colours <- c('England' = '#617a89', 'South East' = '#ff0055', 'West Sussex' = '#0b53c1')

vodd_plot <- ggplot(
  data = df_plot,
  mapping = aes(x = Timeperiod,
                y = Value,
                color = AreaNamePlot,
                group = AreaNamePlot)) + 
  geom_line(size = 2) +
  geom_point(shape=21, size=3, fill = 'white', stroke = 3) +
  theme_wsj() +
  scale_color_manual(values = area_colours) +
  theme(legend.position = c(.5,.1),
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  expand_limits(y=c(0,40)) +
  labs(y = '% of 5 year-olds with obvious dental decay')

print(vodd_plot)

ggsave(vodd_plot, filename = 'visual_dental_decay_5yos.png', path = save_place, bg = 'transparent', units = 'mm', width = 180, height = 180)
