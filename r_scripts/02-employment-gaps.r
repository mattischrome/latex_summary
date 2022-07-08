# Employment gaps 

library(tidyverse)
library(ggthemes)
library(ggtext)

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images'
the_measures <- c('**with a long-term health condition**','**with learning disabilities**','**in contact with secondary mental health services**')
plot_tbl <- tibble(
  measures = the_measures,
  values = c(9.9,78.6,68.7),
  measure_labels = paste("Gap in employment between people",the_measures,"and the overall employment rate")
)

label_delta <- 2 # How far to nudge labels along the x axis

gaps_plot <- ggplot(data = plot_tbl,
                    mapping = aes(x=values, y=reorder(measures,-values), label = measure_labels)) +
  geom_col(fill = '#0b53c1') +
  geom_textbox(nudge_x = label_delta, hjust = 0, box.colour = NA, fill = NA, size = 3, width = grid::unit(0.2, "npc")) +
  labs(y = element_blank(),
       caption = 'Source: OHID Fingertips') +
  scale_y_discrete(breaks = c(1,2,3),
                   labels = c(NA, NA, NA)) +
  scale_x_continuous(limits=c(0,100)) +
  theme_wsj() +
  theme(title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA))

plot(gaps_plot)

ggsave(gaps_plot, filename = 'employment_gaps.png', path = save_place, bg = 'transparent', units = 'mm', width = 180, height = 120)
