library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/JSNA/latex_summary/images/'

# Import EWD data since 1992
# This is in a funny format, which I've already had to clean up a bit before R

ewd_data_ons <- read_csv(paste0(source_place,"wsx_ewd.csv"))

# Like OHID, we exclude Covid-19 from the excess winter deaths index
# Did this at the command line because it was easier

# Pivot wider so one row per year

ewd_data <- ewd_data_ons %>%
  pivot_wider(names_from = Statistic, values_from = Value) %>% 
  mutate(mean = mean(Number),
         sd = sd(Number),
         upper_outer = mean+2*sd,
         upper_inner = mean+sd,
         lower_inner = mean-sd,
         lower_outer = mean-2*sd)

ewd_plot <- ggplot(data = ewd_data,
                   mapping = aes(x=Date, y=Number, group=1)) +
  geom_line(aes(y=mean))+
  geom_line(aes(y=upper_outer), color='red', size=1.1)+
  geom_line(aes(y=upper_inner), color='red', linetype=2)+
  geom_line(aes(y=lower_inner), color='green', linetype=2)+
  geom_line(aes(y=lower_outer), color='green',size=1.1)+
  geom_line(size=2, color='blue')+
  geom_point(shape=21, size=3, fill = 'white', stroke = 3, color='#617a89')+
  theme_wsj()+
  theme(legend.position = c(.8,.1),
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        panel.grid.minor = element_blank(),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(x = '',
       y='Excess Winter Mortality')

print(ewd_plot)

ggsave(paste0(save_place,"ewd_control_chart.png"),ewd_plot,width=180,height=90,units="mm")
