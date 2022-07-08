library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/Projects/JSNA/latex_summary/images/'

# GP Patient Survey - how confident are you in managing your conditions?

# Data generated using online cross tabs tool

data_confident <- tibble(
  age_group = rep(c('Overall','65-74 years','75-84 years','85+ years'),5),
  response = c(rep('Very confident',4),rep('Fairly confident',4),rep('Not very confident',4),rep('Not at all confident',4),rep('Don\'t know',4)),
  value = c(29,35,31,16,54,55,56,54,11,6,9,24,3,1,4,4,3,2,1,2))

data_confident$response <- factor(data_confident$response, levels = c('Very confident', 'Fairly confident', 'Not very confident', 'Not at all confident', 'Don\'t know'))

confident_plot <- ggplot(data = data_confident,
                         mapping = aes(x=rev(response), y=value, group = age_group, fill=age_group))+
  geom_col(position = position_dodge(width=0.9))+
  geom_richtext(aes(label = round(value, digits = 1), group = age_group, y = value+5), position = position_dodge(width = 0.9), color = "black", fill = NA, label.color = NA, size = rel(3), na.rm = TRUE, hjust = 1, vjust = 0.5)+
  theme_wsj()+
  scale_fill_ft() +
  expand_limits(y=c(0,60)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(size = rel(0.4)),
        legend.key.size = unit(4,"mm"),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        plot.title = element_text(family = "sans", size = rel(0.7)),
        plot.subtitle = element_text(family = "sans", size = rel(0.6)),
        plot.caption = element_text(family = "sans",
                                    size = rel(0.4),
                                    hjust = 1),
        axis.text = element_text(family = "sans",
                                 size = rel(0.7)),
        rect = element_rect(fill = "transparent",
                            linetype = 0,
                            colour = NA),
        axis.title.x = element_text(colour = "black",
                                    family = "sans",
                                    size = rel(0.4))) +
  labs(y='% of respondents with a LTC',
       caption = 'Weighted base: 6,296') +
  coord_flip()

print(confident_plot)

ggsave(paste0(save_place,'GPPS_confident_LTC.png'), confident_plot, width = 130, height = 130, units = 'mm')
