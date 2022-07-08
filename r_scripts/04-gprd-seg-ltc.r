library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/Projects/JSNA/latex_summary/images/'

# Specific conditions and percentage of age group identified with LTC

conditions <- c('Hypertension','Asthma','CHD','Diabetes','Depression','COPD','AF','Fall Risk','Mental Health','Stroke / TIA','CHF','CKD','Epilepsy','Dementia','Parkinsons','MS')

fig_data <- tibble(
  condition = rep(conditions,3),
  age = c(rep('65-74 years',length(conditions)),rep('75-84 years',length(conditions)),rep('85+ years',length(conditions))),
  value = c(29.9, 8.8, 8.6, 8.6, 6.6, 5, 4.9, 4.2, 3.2, 1.9, 1.7, 1.4, 1.1, 0.6, 0.5, 0.3, 45.6, 9.9, 16.5, 12.4, 6.1, 7.4, 13.4, 9.6, 3.8, 4.7, 5.3, 3, 1.4, 4.7, 1.4, 0.1, 52.4, 8.6, 20.3, 10, 6.9, 7.7, 21.5, 15.9, 5.4, 7.2, 11.1, 4.3, 1.2, 12.8, 1.2, 0)
)

fig_data$condition <- factor(fig_data$condition, levels = rev(conditions))
fig_data$age <- factor(fig_data$age, levels = c('65-74 years','75-84 years','85+ years'))

cloned_fig <- ggplot(data = fig_data,
                     mapping = aes(x = condition, y = value, fill = age))+
  geom_col(position = position_dodge(0.9)) +
  geom_richtext(aes(label = round(value, digits = 1), group = age, y = ifelse(value>10,value+6,value+4)),
                position = position_dodge(width = 0.9),
                color = "black",
                fill = NA,
                label.color = NA,
                size = rel(3),
                na.rm = TRUE,
                hjust = 1,
                vjust = 0.5) +
  expand_limits(y = c(0,60)) +
  theme_minimal()+
  scale_fill_ft()+
  coord_flip()+
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.x = element_text(colour = "black"),
        axis.text = element_text(colour = "black"))+
  labs(y='% of patients sampled',
       x = element_blank())


print(cloned_fig)

ggsave(paste0(save_place,'GPRD_seg_ltc.png'), cloned_fig, width = 130, height = 130, units = 'mm', dpi = 'print')

