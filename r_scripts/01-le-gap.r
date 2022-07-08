# https://analytics.phe.gov.uk/apps/segment-tool/
library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

# Configure location for source files
source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images'

cols_for_plot <- c('Cause of death','Sex','Percentage contribution to the gap (%)')
phe_data <- read_csv(file = paste0(source_place,'BroadCause.csv'))

differences<- phe_data %>% 
  filter(Geography == 'West Sussex',
         Comparison == 'Within area') %>% 
  select(all_of(cols_for_plot)) %>% 
  rename(
    sex = Sex,
    condition = `Cause of death`,
    value = `Percentage contribution to the gap (%)`) %>% 
  mutate(value = as.numeric(value))

# differences <- tibble(
#   sex = c(rep('Male',8),rep('Female',8)),
#   condition = rep(conditions,2),
#   value = c(25.6,21.1,12.8,8.5,10.3,9.5,9.6,2.6,23.1,21.2,15.3,6,4.6,14.5,14.7,0.6)
# )

differences <- differences %>% 
  mutate(value_labels = ifelse(value >= 2.5, paste0(sprintf('%.1f',value),'%'), NA))
value_breaks <- seq(0,25, by = 5)

# diff_plot <- ggplot(
#   data = differences, 
#   mapping = aes(x = condition, y=value, fill = sex)
# ) + geom_bar(stat = "identity") +
#   facet_grid(rows = vars(sex)) +
#   expand_limits(y=c(0,26)) +
#   theme_wsj() +
#   scale_y_continuous(breaks = value_labels) +
#   theme(legend.position = c(.85,.1),
#         legend.title = element_blank(),
#         legend.text = element_text(size = rel(1)),
#         title = element_text(family = "sans", size = rel(1)),
#         rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
#         axis.title.y = element_text(colour = 'black', size=rel(1))) +
#   labs(x = '',
#        y='Contribution to life expectancy gap (%)') +
#   coord_flip()
# 
# diff_plot

differences_m <- differences %>% 
  filter(sex == 'Male')
differences_m <- transform(differences_m, condition = reorder(condition, value))

differences_f <- differences %>% 
  filter(sex == 'Female')
differences_f <- transform(differences_f, condition = reorder(condition, value))

# How to plot a value according to the factor levels from max to min

diff_plot_m <- ggplot(
  data = differences_m, 
  mapping = aes(y = condition, x=value)
) + geom_bar(stat = "identity", fill='#0b53c1') +
  geom_richtext(aes(label = value_labels), color = 'white', fill = NA, label.color = NA, nudge_x = -1.4, size = rel(4), na.rm = TRUE) +
  geom_richtext(x = 22, y = 1.5, label = '**Males**', stat = 'unique', color = 'black', fill = NA, label.color = NA, size = rel(6), na.rm = TRUE, hjust = 0) +
  expand_limits(x=c(0,26)) +
  theme_wsj(base_size = 10) +
  scale_x_continuous(breaks = value_breaks, limits = c(0,26)) +
  theme(title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.x = element_text(colour = 'black', size=rel(1)),
        axis.title.y = element_blank()) +
  labs(x='Contribution to life expectancy gap (%)')

# +
#   coord_cartesian(clip = 'off') +
#   coord_flip(clip = 'off')

diff_plot_m

diff_plot_f <- ggplot(
  data = differences_f, 
  mapping = aes(y = condition, x=value)
) + geom_bar(stat = "identity", fill='#23d0fc') +
  geom_richtext(aes(label = value_labels), color = 'black', fill = NA, label.color = NA, nudge_x = -1.4, size = rel(4), na.rm = TRUE) +
  geom_richtext(x = 22, y = 1.5, label = '**Females**', stat = 'unique', color = 'black', fill = NA, label.color = NA, size = rel(6), na.rm = TRUE, hjust = 0) +
  expand_limits(x=c(0,26)) +
  theme_wsj(base_size = 10) +
  scale_x_continuous(breaks = value_breaks, limits = c(0, 26)) +
  theme(title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.x = element_text(colour = 'black', size=rel(1)),
        axis.title.y = element_blank()) +
  labs(x='Contribution to life expectancy gap (%)')

# +
#   coord_cartesian(clip = 'off') +
#   coord_flip(clip = 'off')

diff_plot_f

ggsave(diff_plot_m, filename = 'male_life_expectancy_gap.png', path = save_place, bg = 'transparent', units = 'mm', width = 195, height = 78)
ggsave(diff_plot_f, filename = 'female_life_expectancy_gap.png', path = save_place, bg = 'transparent', units = 'mm', width = 195, height = 78)
 