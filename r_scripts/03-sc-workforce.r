# Estimated number of social care staff (all sector)
# https://www.skillsforcare.org.uk/adult-social-care-workforce-data-old/Workforce-intelligence/documents/Local-authority-area-summary-reports/South-East/2021/West-Sussex-Summary-2021.pdf

library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images/'

sector_data <- tibble(
  sector = c('Domiciliary Care', 'Residential Care', 'Community', 'Day Services'),
  value = c(9100,14500,1000,300)
)

sector_data$sector <- factor(sector_data$sector, levels = c('Domiciliary Care', 'Residential Care', 'Community', 'Day Services'))

fact_1 <- '27% of workers are\nover 55'
fact_2 <- 'Average Age = 44'
fact_3 <- '82% female'
fact_4 <- '23% of worker on zero\nhours contracts'
fact_5 <- 'On average 8.8 days of\nsickness per year'

sector_plot <- ggplot(data = sector_data,
                      mapping = aes(x=sector, y=value))+
  geom_col() +
  geom_text(label = sector_data$value, nudge_y = ifelse(sector_data$value>5000, -500,500), fontface = 'bold', color = ifelse(sector_data$value<5000, 'black','white')) +
  theme_wsj() +
  scale_fill_ft() +
  theme(title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y = 'Number of workers')

print(sector_plot)

ggsave(filename = paste0(save_place,'03-sc-workforce.png'), plot = sector_plot, width = 18, height = 13, units = 'cm', dpi = 'print')
