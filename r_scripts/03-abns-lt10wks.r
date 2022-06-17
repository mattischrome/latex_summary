# 03-abns-lt10wks.r 
# Under 25s repeat abortions (%)

# Packages
library(tidyverse)
library(hrbrthemes)
library(ggthemes)
library(ggtext)

# Configure location for source files
source_place <- '~/Documents/JSNA/latex_summary/data_sources'

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images'

# We don't use the fingertips package for this as it doesn't return local authority
# level data. Instead we'll build a tibble based on data from the fingertips website.

df <- tibble(
  Timeperiod = rep(seq.int(2012,2020),2),
  AreaName = c(rep("West Sussex",9), rep("England",9)),
  Value = c(75.8,77.6,NA,79.4,78.2,73.4,77.2,80.2,88.7,77.5,79.4,80.4,80.3,80.8,76.6,80.3,82.5,88.1)
)

YYYY="Abortions under 10 weeks (%)"

indicator_timeperiod <- df$Timeperiod %>% unique() %>% sort()
indicator_timeperiod[seq(2,length(indicator_timeperiod),2)] <- ''

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
  expand_limits(y = c(70, 90)) +
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

ggsave(plot, filename = paste0("abortions_lt_10wks_line",".png"),path = save_place, bg = 'transparent', units = 'mm', width = 220, height = 90)
