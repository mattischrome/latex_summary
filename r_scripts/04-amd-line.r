library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)
library(fingertipsR)

source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/Projects/JSNA/latex_summary/images/'

# Preventable sight loss (AMD)
le_indicator <- 41201
the_indicator <- "Preventable sight loss - age related macular degeneration (AMD)"
ZZZZ <- "amd_line"

df <- fingertips_data(IndicatorID = le_indicator, AreaTypeID = 102)
areas_of_interest <- c('England', 'South East Region', 'West Sussex')

df <- df %>% 
  filter(AreaName %in% areas_of_interest) %>% 
  filter(Sex == 'Persons') %>% 
  filter(TimeperiodSortable >= 20100000)

amd_plot <- ggplot(data = df,
                   mapping = aes(x=Timeperiod, y=Value, group = AreaName, colour = AreaName)) +
  geom_line(size = 2) +
  geom_point(shape=21, size=3, fill = 'white', stroke = 3) +
  theme_wsj() +
  scale_color_ft() +
  theme(legend.position = c(.8,.1),
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA))

print(amd_plot)

ggsave(paste0(save_place,ZZZZ,'.png'), amd_plot, width = 180, height = 90, units = "mm", dpi = "print")
