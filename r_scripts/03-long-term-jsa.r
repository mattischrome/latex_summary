library(tidyverse)
library(ggthemes)
library(hrbrthemes)

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images'

the_data <- tibble(
  location = c('England','West Sussex','Worthing','Adur','Arun','Crawley','Chichester','Horsham','Mid Sussex'),
  location_type = c('Country','County',rep('District and Borough',7)),
  claimants = c(56020, 480, 70, 40, 100, 115, 85, 30, 30),
  population = c(33605600,479600,62600,35100,82400,69000,63200,81000,86400),
  rate = claimants/population*1000
)

the_data$location <- factor(the_data$location, levels = rev(c('England','West Sussex','Crawley','Chichester','Arun','Adur','Worthing','Horsham','Mid Sussex')))

the_plot <- ggplot(data = the_data,
                   mapping = aes(x = location, y = rate, fill = location_type)) +
  geom_col() +
  theme_wsj() +
  scale_fill_manual(values = c('#222222','#221177','#2166ed')) +
  coord_flip() +
  theme(title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        legend.position = 'none',
        axis.title.x = element_text(colour = 'black', size=rel(1))) +
  labs(y = "Rate / 1,000 16-64 year olds",
       caption = "Source: NOMIS")
the_plot

ggsave(the_plot, filename = 'longterm_jsa_claimants_wsx.png', path = save_place, bg = 'transparent', units = 'mm', width = 180, height = 90)
