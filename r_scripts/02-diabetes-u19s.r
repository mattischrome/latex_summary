# Admissions for diabetes for children and young people aged under 19 years
library(tidyverse)

indicator <- 'Admissions for diabetes for children and young people aged under 19 years'

diabetes_u19 <- tibble(
  period = c("2010/11", "2011/12", "2012/13", "2013/14", "2014/15", "2015/16", "2016/17", "2017/18", "2018/19", "2019/20"),
  count = c(108, 144, 116, 115, 120, 95, 120, 95, 95, 115),
  value = c(62.4, 82.8, 66, 65, 67.2, 52.8, 66.1, 52, 51.7, 62.2),
  LCI = c(51.2, 69.9, 54.6, 54.2, 55.2, 41.7, 53.8, 42.1, 41.3, 52.3),
  UCI = c(75.4, 97.5, 79.2, 78.7, 79.8, 63.3, 77.9, 63.6, 62.6, 75.8),
  SouthEast = c(61.5, 59.1, 58.9, 57.6, 57.2, 56.7, 52.1, 49, 44.4, 48),
  England = c(64.1, 60.8, 60.4, 57, 55.9, 55.4, 55.1, 51.4, 50.7, 51.9),
  DataNote = c(FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE))

diabetes_u19s_text <- paste('There were',count,indicator,'in the period',period,'. This is a rate of',value,'per 100,000 population, which is significantly higher than the England rate, as can be seen in Figure~\ref{fig:diabetes_u19s}.')