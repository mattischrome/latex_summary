library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

# Configure location for source files
source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images/'

the_data <- tibble(
  measure = c(rep('Achieving a\ngood level of\ndevelopment\n(Foundation\nstage)',2),
              rep('Achieving the\nexpected level in\nthe phonics\nscreening (Key\n stage 1 - at the\nend of Year 1)',2),
              rep('Achieving the\nexpected standard\nin reading, writing\nand maths (Key\nStage 2)',2)),
  status = rep(c('All pupils', 'Pupils with free school meal status'),3),
  value = c(71.9,51,81,63,63,38)
)

the_plot <- ggplot(
  data = the_data,
  mapping = aes(x = measure,
                y = value,
                group = status,
                fill = status)) +
  geom_col(position = position_dodge()) +
  geom_text(aes(label = value, y = value + 4), vjust = 0, position = position_dodge(0.9))+
  theme_wsj() +
  scale_fill_ft() +
  expand_limits(y=c(0,100)) +
  theme(legend.position = 'top',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        plot.title.position = 'plot',
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1)),
        strip.text = element_blank()) +
  labs(y = '% of children')

print(the_plot)
ggsave(the_plot, filename = '02_school_readiness_2019.png', path = save_place, bg = 'transparent', units = 'mm', width = 180, height = 90)
