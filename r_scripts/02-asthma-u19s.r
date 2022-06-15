# Hospital admissions for asthma (under 19 years)
# https://fingertips.phe.org.uk/search/asthma#page/4/gid/1/pat/6/ati/402/are/E10000032/iid/90810/age/220/sex/4/cat/-1/ctp/-1/yrr/1/cid/4/tbm/1/page-options/car-do-0
library(tidyverse)

indicator <- 'hospital admissions for asthma in under 19s'
indicator_tc <- str_to_title(indicator)

asthma_u19s <- tibble(
   period = c("2013/14", "2014/15", "2015/16", "2016/17", "2017/18", "2018/19", "2019/20", "2020/21"),
   count = c(290, 285, 270, 225, 235, 185, 215, 100),
   value = c(163.9, 159.7, 150.1, 124, 128.7, 100.7, 116.3, 53.8),
   LCI = c(146.1, 142.2, 133.2, 109.3, 113.3, 86.7, 100.3, 43.8),
   UCI = c(184.5, 179.9, 169.7, 142.5, 146.9, 116.3, 131.8, 65.4),
   SouthEast = c(155.2, 173.5, 166.2, 166.7, 153.3, 132.6, 125.9, 54.7),
   England = c(197.2, 216.1, 202.4, 202.8, 186.4, 178.4, 160.7, 74.2)
)

asthma_u19s_text <- paste('There were',count,indicator,'in the period',period,'. This is a rate of',value,'per 100,000 population, which is significantly lower than the England rate. However, while rates locally and nationally have been falling, admissions will have been impacted by Covid-19 as can be seen in Figure~\ref{fig:asthma_u19s}.')

# pivot the tibble to keep value and England, labelled by region
asthma_u19s_piv <- asthma_u19s %>% 
  select(c('period','value','England')) %>% 
  pivot_longer(cols=c('value','England'), names_to = 'region') %>% 
  mutate(region = ifelse(region=='value','West Sussex','England'))

# Chart
asthma_u19s_chart <- ggplot(data = asthma_u19s_piv,
                            mapping = aes(x = period, y=value, group= region, colour = region)) + geom_line()
asthma_u19s_chart
