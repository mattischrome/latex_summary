# HLE compared to cipfa_neighbours
# Packages
library(tidyverse)
library(hrbrthemes)
library(fingertipsR)
library(ggthemes)
library(ggtext)
library(patchwork)

wsx_indicator <- function(x) {
  case_when(
    x == 'West Sussex' ~ 'West Sussex',
    x == 'England' ~ 'England',
    is.character(x) == TRUE ~ 'CIPFA Neighbour'
  )
}

# Configure location for source files
source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images'

# Fingertips-y stuff
inds <- indicators()
inds_hle <- inds[grep('Healthy life expectancy',inds$IndicatorName),]

wsx_cipfa_neighbours <- nearest_neighbours('E10000032',AreaTypeID = 102, measure = 'CIPFA')
areas_of_interest <- c('E92000001', 'E12000008', 'E10000032', wsx_cipfa_neighbours)

hle_indicator <- 90362

df <- fingertips_data(IndicatorID = hle_indicator, AreaTypeID = 102)

df_before <- df %>% 
  filter(Sex == 'Female') %>% 
  filter(AreaCode %in% areas_of_interest) %>% 
  filter(TimeperiodSortable == min(TimeperiodSortable)) %>% 
  mutate(barFill = wsx_indicator(AreaName)) %>% 
  mutate(AreaName = fct_rev(fct_reorder(factor(AreaName),Value,max))) %>% 
  mutate(AreaLabel = ifelse(AreaName %in% c('West Sussex', 'England'),barFill,''))

df_now <- df %>% 
  filter(Sex == 'Female') %>% 
  filter(AreaCode %in% areas_of_interest) %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>% 
  mutate(barFill = wsx_indicator(AreaName)) %>% 
  mutate(AreaName = fct_rev(fct_reorder(factor(AreaName),Value,max))) %>% 
  mutate(AreaLabel = ifelse(AreaName %in% c('West Sussex', 'England'),barFill,''))

area_colours <- c('England' = '#617a89', 'CIPFA Neighbour' = '#909495', 'West Sussex' = '#0b53c1')

# Each plot needs a text label on the West Sussex and England bars
# We also need a text label wih the date value to overlay on the bars

before_label <- paste0('**',df_before[1,'Timeperiod'],'**')
now_label <- paste0('**',df_now[1,'Timeperiod'],'**')

plot_before <- ggplot(
  data = df_before,
  mapping = aes(x = AreaName, y = Value, fill = barFill, group = barFill)) +
  geom_bar(stat = 'identity') + 
  geom_richtext(aes(label = AreaLabel), color = 'white', fill = NA, label.color = NA, size = rel(4), na.rm = TRUE, y = 10, angle = 90, hjust = 0) +
  geom_richtext(label = before_label, stat = 'unique', x = 6, y = 5, fill = NA, label.color = NA, size = rel(6))+
  scale_fill_manual(values = area_colours)+
  theme_wsj() +
  scale_color_ft() +
  theme(legend.position = 'none',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.line.x = element_line(size = 0),
        axis.ticks.x = element_line(size = 0),
        axis.text.x = element_blank(),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y='Female HLE (years)')

print(plot_before)

plot_now <- ggplot(
  data = df_now,
  mapping = aes(x = AreaName, y = Value, fill = barFill, group = barFill)) +
  geom_bar(stat = 'identity') + 
  geom_richtext(aes(label = AreaLabel), color = 'white', fill = NA, label.color = NA, size = rel(4), na.rm = TRUE, y = 10, angle = 90, hjust = 0) +
  geom_richtext(label = now_label, stat = 'unique', x = 6, y = 5, fill = NA, label.color = NA, size = rel(6))+
  scale_fill_manual(values = area_colours)+
  theme_wsj() +
  scale_color_ft() +
  theme(legend.position = 'none',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.line.x = element_line(size = 0),
        axis.ticks.x = element_line(size = 0),
        axis.text.x = element_blank(),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y='Female HLE (years)')

print(plot_now)

# Could probably use patchwork to put these plots together

final_plot <- plot_before / plot_now

ggsave(final_plot, filename = 'hle_cipfa.png', path = save_place, bg = 'transparent', units = 'mm', width = 180, height = 180)
