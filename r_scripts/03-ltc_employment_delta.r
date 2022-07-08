# 2.2 Employment of people with long-term conditions
# Summary
# The percentage point difference between the rate of employment in the general population of working age (16-64) and the rate of employment amongst adults of working age with a long-term condition.
# This indicator measures the extent to which people with long-term conditions are able to live as normal a life as possible by looking at their levels of employment.

library(tidyverse)
library(ggthemes)

makeSortable <- function(Year, Quarter){
  # Converts 2020 Q1 to 2020000
  # Converts 2020 Q2 to 2020250
  # Converts 2020 Q3 to 2020500
  # Converts 2020 Q4 to 2020750
  value = 1000 * (Year + ((Quarter-1)/4))
}

# Configure location for source files
source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images'

# Read in the data 
# Need to clean off the footnotes from the year figures
ltc <- read_csv(file = '~/Documents/Projects/JSNA/latex_summary/data_sources/NHSOF_2.2_I00707_D.csv') %>% 
  separate(Year,into = c('Year','Note'),sep = 4) %>% 
  select(-Note) %>% 
  mutate(Year = as.numeric(Year)) %>% 
  mutate(TimeperiodSortable = makeSortable(Year, Quarter)) %>% 
  rename(Value = `Indicator value`) %>% 
  mutate(Value = as.numeric(Value))
# View(ltc)
# unique(ltc$Level)


# Pull out England, South East region, West Sussex, and CIPFA neighbours

# England
ltc_eng <- ltc %>% 
  filter(Breakdown == 'England')

ltc_eng_plot <- ggplot(data = ltc_eng,
                       mapping = aes(x = TimeperiodSortable, y = Value)) + geom_line()
print(ltc_eng_plot)

my_levels <- c('England', 'South East', 'West Sussex', 'Cambridgeshire', 'Devon', 'East Sussex', 'Essex', 'Gloucestershire', 'Hampshire', 'Kent', 'North Yorkshire', 'Northamptonshire', 'Oxfordshire', 'Somerset', 'Staffordshire', 'Suffolk', 'Warwickshire', 'Worcestershire')

ltc_levels <- ltc %>% 
  filter(Level %in% my_levels) %>% 
  mutate(CIPFA_status = ifelse(Level %in% c('England', 'South East', 'West Sussex'), Level, 'CIPFA Neighbours'),
         CIPFA_line = ifelse(Level %in% c('England', 'South East', 'West Sussex'), 1.1, 1),
         CIPFA_status = factor(CIPFA_status, levels = c('CIPFA Neighbours', 'South East', 'England','West Sussex')),
         Level = factor(Level, levels = rev(my_levels)))

colourvalues <- c('England' = '#617a89', 'CIPFA Neighbours' = '#dddddd', 'West Sussex' = '#0b53c1', 'South East' = '#0b4f6c')

# Plot change over time for these
# This code also plots the CIPFA neighbours as thinner sparklines with the other data thicker on top
# (But not as thick as the default values)

ltc_lev_plot <- ggplot(data = ltc_levels,
                       mapping = aes(x = TimeperiodSortable/1000, y = Value, group = Level, colour = CIPFA_status)) + 
  geom_line(aes(size = as.numeric(CIPFA_line))) +
  scale_size(range = c(1, 2), guide = guide_none()) +
  theme_minimal() +
  scale_colour_manual(values = colourvalues) +
  theme_wsj()+
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.key.size = unit(2,'line'),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y='Indicator value')
print(ltc_lev_plot)

ggsave(ltc_lev_plot, filename = 'ltc_employment_delta_cipfa.png', path = save_place, bg = 'transparent', units = 'mm', width = 180, height = 180)
