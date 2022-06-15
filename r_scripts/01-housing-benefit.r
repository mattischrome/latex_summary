library(tidyverse)

source_dir <- '~/Documents/JSNA/latex_summary/data_sources/'
output_dir <- '~/Documents/JSNA/latex_summary/images/'

housing_benefits <- read_csv(paste0(source_dir,'Housing-benefit-recipients-nov-21.csv'))

housing_benefits <- housing_benefits %>% pivot_longer(cols = c("Month_2021_October","Month_2021_November"), values_to = 'Number of housing benefit recipients') %>% rename('Month' = name) %>% mutate(Month = str_replace(Month, 'Month_2021_', ''),Year = '2021')

