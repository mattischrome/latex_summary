# 03-under25-rpt-abn-line_v2.r 
# Under 25s repeat abortions (%)

# Packages
library(tidyverse)
library(hrbrthemes)
library(ggthemes)
library(ggtext)

# Configure location for source files
source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources'

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images'

# We don't use the fingertips package for this as it doesn't return local authority
# level data. Instead we'll build a tibble based on data from the fingertips website.

df <- tibble(
  Timeperiod = rep(seq.int(2012,2020),2),
  AreaName = c(rep("West Sussex",9), rep("England",9)),
  Value = c(24.2,25.3,21.6,23.7,28.6,23.7,24.7,25.4,25.5,27.1,26.9,27.0,26.5,26.7,26.7,26.8,27.7,29.2)
)

YYYY <- "Under 25s repeat abortions (%)"

indicator_timeperiod <- df$Timeperiod %>% unique() %>% sort()
indicator_timeperiod[seq(1,length(indicator_timeperiod),2)] <- ''

# caption_data <- df %>% 
#   filter(TimeperiodSortable == max(TimeperiodSortable)) %>% 
#   select(AreaName,Value,Timeperiod) %>% 
#   mutate(Value = round(Value,1))
# 
# caption <- paste0('**',str_replace_all(caption_data[2,3],' ',''),' ',YYYY,'**<br>',caption_data[2,1],' = ',caption_data[2,2],' per 100,000 population<br>',caption_data[1,1],' = ',caption_data[1,2],' per 100,000 population')

plot <- ggplot(
  data = df,
  mapping = aes(x = Timeperiod, y = Value, color = AreaName, group=AreaName))+
  geom_line(size=2) +
  geom_point(shape=21, size=3, fill = 'white', stroke = 3) +
  expand_limits(y = c(0, 40)) +
  theme_wsj() +
  scale_color_ft() +
  theme(legend.position = c(.85,.1),
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y=YYYY)

plot

ggsave(plot, filename = paste0("repeat_abortions_line",".png"),path = save_place, bg = 'transparent', units = 'mm', width = 235, height = 130)
