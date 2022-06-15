library(tidyverse)
library(ggthemes)
library(hrbrthemes)

# Configure location for source files
source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images/'

carers_allowance_data <- tibble(
  Age = rep(c('Under 18','18-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65 and over'),2),
  Gender = c(rep('Male',11),rep('Female',11)),
  Value = c(0,128,110,171,162,191,225,294,326,397,1352,16,163,314,740,913,906,766,844,881,906,2130)
)

carers_allowance_data$Age <- factor(carers_allowance_data$Age, levels = c('Under 18','18-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65 and over'), labels = c('Under 18','18-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65 and over'))
carers_allowance_data$Gender <- factor(carers_allowance_data$Gender, levels = c('Male', 'Female'), labels = c('Male', 'Female'))

carers_plot <- ggplot(data = carers_allowance_data,
                      mapping = aes(x=Age, y=Value, fill = Gender)) +
  geom_col(position = position_stack()) +
  theme_wsj() + 
  scale_fill_ft() +
  coord_flip() +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        plot.title.position = 'plot',
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.x = element_text(colour = 'black', size=rel(1)),
        strip.text = element_blank()) +
  labs(x = 'Number of carers',
       caption = 'Source: DWP Stat X-plore November 2021',
       title = 'Carers Allowance - November 2021',
       subtitle = 'Age and Gender of Claimants in West Sussex')

print(carers_plot)
ggsave(carers_plot, filename = 'carers_allowance_recipients.png', path = save_place, bg = 'transparent', units = 'mm', width = 235, height = 130)
