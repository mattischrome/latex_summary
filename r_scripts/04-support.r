library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/JSNA/latex_summary/images/'

# Stacked bar chart with responses to question about support from local organisations and services

age_bands <- c('Overall', '16-24 years', '25-34 years', '35-44 years', '45-54 years', '55-64 years', '65-74 years', '75-84 years', '85+ years')

response_bands <- c('Yes, definitely', 'Yes, to some extent', 'No', 'I haven\'t needed support', 'Don\'t know / can\'t say')

age_bands_vec <- lapply(lapply(age_bands,rep,length(response_bands)),c) %>% unlist()


the_base <- 'Weighted base: 6216'

support_data <- tibble(
  age = age_bands_vec,
  response = rep(response_bands,length(age_bands)),
  values = c(26,25,16,30,3,
             16,31,27,19,7,
             26,30,22,20,2,
             22,30,22,22,4,
             28,26,19,23,4,
             27,26,14,31,2,
             29,22,9,38,2,
             26,20,11,40,3,
             28,28,13,28,3)
)

support_data$age <- factor(support_data$age, levels = age_bands)
support_data$response <- factor(support_data$response, levels = response_bands)

support_plot <- ggplot(data = support_data,
                       mapping = aes(x=age, y=values, group=response, fill=response))+
  geom_col(position = position_stack())+
  theme_wsj()+
  scale_fill_manual(values=c('#4daf4a','#377eb8','#e41a1c','#984ea3','#ff7f00'))+
  expand_limits(y=c(0,100))+
  labs(y='% of respondents',
       caption = the_base) +
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
                                 size = rel(0.6)),
        rect = element_rect(fill = "transparent",
                            linetype = 0,
                            colour = NA),
        axis.title.x = element_text(colour = "black",
                                    family = "sans",
                                    size = rel(0.3)))+
  coord_flip()

print(support_plot)

ggsave(paste0(save_place,'GPPS_support.png'),support_plot,width=130,height=130,units='mm',dpi='print')
