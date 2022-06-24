library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/JSNA/latex_summary/images/'

data_18_to_64 <- tibble(
  location = rep(c('West Sussex','England'),3),
  route = c(rep('Other',2),rep('Hospital Discharge',2),rep('Community',2)),
  value = c(45,13730,220,47560,5700,516510)
)

data_18_to_64_plot <- ggplot(data = data_18_to_64,
                             mapping = aes(y=location, x=value, group=route, fill=route))+
  geom_col(position = 'fill') +
  scale_x_percent() + 
  theme_wsj()+
  scale_fill_ft()+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(size = rel(0.7)),
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
                            colour = NA))

print(data_18_to_64_plot)

ggsave(paste0(save_place,'new_sc_requests_18_to_64.png'), data_18_to_64_plot, width = 130, height = 65, units = 'mm')


data_65_plus <- tibble(
  location = rep(c('West Sussex','England'),3),
  route = c(rep('Other',2),rep('Hospital Discharge',2),rep('Community',2)),
  value = c(275,30855,2580,317090,14225,990630)
)

data_65_plus_plot <- ggplot(data = data_65_plus,
                             mapping = aes(y=location, x=value, group=route, fill=route))+
  geom_col(position = 'fill') +
  scale_x_percent() + 
  theme_wsj()+
  scale_fill_ft()+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(size = rel(0.7)),
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
                            colour = NA))

print(data_65_plus_plot)

ggsave(paste0(save_place,'new_sc_requests_65_plus.png'), data_65_plus_plot, width = 130, height = 65, units = 'mm')

### Number of new requests over time from the awful NHS Digital Power BI dash

new_reqs_vs_time <- read_csv(paste0(source_place,"new_support_requests_time.csv"))

new_reqs_vs_time_plot <- ggplot(data = new_reqs_vs_time %>% filter(Location=='West Sussex'),
                                mapping = aes(x = Date, y = Value, group = Age, color = Age))+
  geom_line(size=2) +
  geom_point(shape=21, size=3, fill = 'white', stroke = 3) +
  theme_wsj() +
  scale_color_ft() +
  theme(legend.position = c(.8,.05),
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y='Number of new requests for support')

print(new_reqs_vs_time_plot)

ggsave(paste0(save_place,'new_sc_requests_line.png'), new_reqs_vs_time_plot, width = 160, height = 90, units = 'mm')
