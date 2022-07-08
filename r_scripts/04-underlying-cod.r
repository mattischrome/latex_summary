library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/Projects/JSNA/latex_summary/images/'

# Underlying cause of death in West Sussex, 2020

conditions <- c('Cancer','Diseases of the circulatory system','Diseases of the respiratory system','Mental and behavioural disorders','Diseases of the nervous system','Codes for special purposes','Other - not elsewhere classified','Diseases of the digestive system','External causes','Diseases of the genitourinary system','Endocrine, nutritional and metabolic diseases','Diseases of the musculoskeletal system / connective tissue','Infectious and parasitic diseases','Diseases of the skin and subcutaneous tissue','Diseases of the blood - involving the immune mechanism','Congenital malformations etc','Aged under 28 days - cause unclassified') %>% str_wrap(.,30)

cause_of_death_wsx <- tibble(
  cause = conditions,
  number = c(2720, 2185, 1012, 872, 840, 725, 467, 440, 338, 147, 142, 71, 66, 29, 19, 17, 15),
  location = rep("West Sussex",17))

cause_of_death_wsx$cause <- factor(cause_of_death_wsx$cause, levels = rev(conditions))

cause_of_death_wsx_plot <- ggplot(data = cause_of_death_wsx,
                                  mapping = aes(y=cause, x=number))+
  geom_col(fill="#0b53c1")+
  geom_richtext(aes(label = number),
                color = "black",
                fill = "white",
                label.color = NA,
                nudge_x = 2,
                size = rel(2),
                na.rm = TRUE,
                hjust = 0,
                vjust = 0.5) +
  theme_wsj()+
  scale_fill_ft()+
  expand_limits(x=c(0,3000))+
  theme(legend.position = "none",
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        plot.title = element_text(family = "sans", size = rel(0.7)),
        plot.subtitle = element_text(family = "sans", size = rel(0.6)),
        plot.caption = element_text(family = "sans",
                                    size = rel(0.6),
                                    hjust = 0),
        axis.text = element_text(family = "sans", size = rel(0.3)),
        rect = element_rect(fill = "white",
                            linetype = 0,
                            colour = NA))

print(cause_of_death_wsx_plot)

ggsave(paste0(save_place,"underlying_cause_of_death.png"),cause_of_death_wsx_plot,width=110,height=110,units="mm")
