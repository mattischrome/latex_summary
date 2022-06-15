# 03-ct-screen.r 
# Proportion aged 15-24 screened for Chlamydia

# Packages
library(tidyverse)
library(hrbrthemes)
library(fingertipsR)
library(ggthemes)
library(ggtext)

# Configure location for source files
source_place <- '~/Documents/JSNA/latex_summary/data_sources'

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images'

# Fingertips-y stuff
inds <- indicators()


### MY VARIABLES
XXXX <- 90777
YYYY <- "Chlamydia proportion aged 15 to 24 screened"
ZZZZ <- "ct_screened_line"


##
le_indicator <- XXXX

df <- fingertips_data(IndicatorID = le_indicator, AreaTypeID = 102)
areas_of_interest <- c('England', 'South East Region', 'West Sussex')

df <- df %>% 
  filter(AreaName %in% areas_of_interest) %>% 
  filter(Sex == 'Persons')


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
  expand_limits(y = c(0, 10)) +
  scale_x_discrete(labels = indicator_timeperiod) +
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

ggsave(plot, filename = paste0(ZZZZ,".png"),path = save_place, bg = 'transparent', units = 'mm', width = 235, height = 130)
