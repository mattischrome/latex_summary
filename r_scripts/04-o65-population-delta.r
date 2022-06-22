library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/JSNA/latex_summary/images/'

population_deltas_o65 <- tibble(
  year = seq.int(2011,2030,1),
  value = c(3300, 6400, 4800, 4700, 3000, 3200, 2700, 2600, 3300, 2200, 4422, 3383, 3946, 4207, 4144, 4768, 4908, 5203, 5558, 5624),
  status = c(rep('estimate/actual',10),rep('projection',10))
)

deltas_plot <- ggplot(data = population_deltas_o65,
                      mapping = aes(x = year, y = value, fill = status)) +
  geom_col()+
  theme_wsj()+
  scale_fill_ft()+
  theme(legend.title = element_blank(),
        legend.position = 'bottom',
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA))

deltas_plot

ggsave(paste0(save_place,'over65_popn_deltas.png'),deltas_plot,width = 180,height = 90,units = 'mm',dpi = 'print')
