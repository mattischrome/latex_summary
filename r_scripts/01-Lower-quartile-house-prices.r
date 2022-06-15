library(tidyverse)
library(ggthemes)
library(hrbrthemes)

setwd('~/Documents/JSNA/latex_summary/')

source_place <- paste0(getwd(),'/data_sources')
save_place <- pasete0(getwd(),'/images')

to_quarters <- function(x){
  # Matches quarter to month end
  # Dec = Q3, Mar = Q4, Jun = Q1, Sep = Q2
  y = case_when(
    x == 'Dec' ~ 'Q3',
    x == 'Mar' ~ 'Q4',
    x == 'Jun' ~ 'Q1',
    x == 'Sep' ~ 'Q2'
  )
}

ltla_filename <- 'LTLA_lower_quartile_house_prices.csv'
county_filename <- 'county_lower_quartile_house_prices.csv'
regional_filename <- 'Regional_lower_quartile_house_prices.csv'

lqhp_ltla <- read_csv(paste(source_place,ltla_filename,sep='/'))
lqhp_county <- read_csv(paste(source_place,county_filename,sep='/'))
lqhp_region <- read_csv(paste(source_place,regional_filename,sep='/'))

# LOWER TIER LOCAL AUTHORITIES
lqhp_ltla <- lqhp_ltla %>%
  pivot_longer(cols = starts_with('Year ending'), names_to = 'Year ending', values_to = 'Price')

lqhp_ltla$`Year ending` <- str_remove(lqhp_ltla$`Year ending`, 'Year ending ')

lqhp_ltla <- lqhp_ltla %>% separate(col = 'Year ending', into = c('Month', 'Year'))

lqhp_ltla <- lqhp_ltla %>% mutate(Quarter = to_quarters(Month)) %>% 
  select(-Month)

west_sussex_dabs <- c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing')

wsx_lqhp_ltla <- lqhp_ltla %>% filter(`Local authority name` %in% west_sussex_dabs)

# UPPER TIER LOCAL AUTHORITIES

lqhp_county <- lqhp_county %>%
  pivot_longer(cols = starts_with('Year ending'), names_to = 'Year ending', values_to = 'Price')

lqhp_county$`Year ending` <- str_remove(lqhp_county$`Year ending`, 'Year ending ')

lqhp_county <- lqhp_county %>% separate(col = 'Year ending', into = c('Month', 'Year'))

lqhp_county <- lqhp_county %>% mutate(Quarter = to_quarters(Month)) %>% 
  select(-Month)

wsx_lqhp_county <- lqhp_county %>% filter(`Local authority name` == 'West Sussex')

# REGIONAL DATA

lqhp_region <- lqhp_region %>%
  pivot_longer(cols = starts_with('Year ending'), names_to = 'Year ending', values_to = 'Price')

lqhp_region$`Year ending` <- str_remove(lqhp_region$`Year ending`, 'Year ending ')

lqhp_region <- lqhp_region %>% separate(col = 'Year ending', into = c('Month', 'Year'))

lqhp_region <- lqhp_region %>% mutate(Quarter = to_quarters(Month)) %>% 
  select(-Month)

wsx_lqhp_region <- lqhp_region %>% filter(`Local authority name` %in% c('South East', 'England'))

jsna_lqhp <- rbind(wsx_lqhp_ltla,wsx_lqhp_county,wsx_lqhp_region)
