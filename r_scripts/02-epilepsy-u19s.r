
library(tidyverse)

indicator <- 'Admissions for epilepsy for children and young people aged under 19 years'

epilepsy_u19 <- tibble(
  period = c("2010/11", "2011/12", "2012/13", "2013/14", "2014/15", "2015/16", "2016/17", "2017/18", "2018/19", "2019/20"),
  count = c(106, 101, 101, 130, 90, 130, 90, 115, 125, 125),
  value = c(61.3, 58.1, 57.5, 73.5, 50.4, 72.3, 49.6, 63, 68, 67.6),
  LCI = c(50.2, 47.3, 46.8, 61.4, 40.5, 59.9, 38.9, 52.5, 57.6, 55.8),
  UCI = c(74.1, 70.6, 69.9, 87.3, 62, 85.2, 59.7, 76.2, 82.2, 80),
  SouthEast = c(74, 71.4, 67.9, 70.6, 75.1, 74.5, 62.7, 71.6, 72.0, 76.5),
  England = c(79.2, 78.5, 75.6, 77.7, 74.7, 76.6, 72.1, 72.6, 76.7, 78.2),
  DataNote = c(FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE)
)

epilepsy_u19s_text <- paste('There were',count,indicator,'in the period',period,'. This is a rate of',value,'per 100,000 population, which is similar to the England rate, as can be seen in Figure~\ref{fig:epilepsy_u19s}.')