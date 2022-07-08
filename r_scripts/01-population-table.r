# Table of population estimates for JSNA summary

# This incorporates population estimates by 5 year age band from 2016 to 2020 - 5 years including most recent updates
# and population projections by 5 year age bands for 2021 to 2025 - a 5 year forecast

# SOURCE: ONS via NOMIS website

library(tidyverse)
library(huxtable)

data_source <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

# For some reason ests get read in as nums and projs as ints - WHY?!?!?! FFS
# So I'm having to force col_types
ests <- read_csv(paste0(data_source,'wsx_mye_ests_5ya_2016_2020.csv'), col_types = 'ciiiii')
projs <- read_csv(paste0(data_source,'wsx_pop_proj_5ya_2021_2025.csv'), col_types = 'ciiiii')

# Pretty sure I selected 'round to the nearest 100 on Nomis' but anyway...
projs <- projs %>% 
  mutate(across(where(is.integer), ~as.integer(plyr::round_any(.x, 100))))

# In ests we need to put Age 0 and Age 1-4 together
rows_to_sum <- c('Aged under 1 year','Aged 1 - 4 years')
new_row_name <- 'Aged 0 - 4 years'

new_row <- ests %>% filter(Age %in% rows_to_sum) %>% 
  summarise(across(where(is.numeric), ~as.integer(sum(.x, na.rm = TRUE)))) %>%
  mutate(Age = new_row_name) %>% 
  select(Age,everything())


ests <- ests %>% 
  add_row(new_row, .before = 4) %>% 
  filter(!Age %in% rows_to_sum)

projs <- projs %>% 
  mutate(Age = ests$Age)

full_table <- ests %>% 
  left_join(projs, by = 'Age')

names(full_table) <- gsub("^X","",names(full_table))

# Version 1 - using library(xtable)
# We'll show the grouping of estimates and projections by hand in Latex
# So all that remains is to export the table to LaTeX

# print(xtable(full_table), format.args = list(big.mark = ",", decimal.mark = "."), include.rownames = FALSE)

# version 2 using huxtable to give us differnet coloured backgrounds for estimates and projections
# Convert the tibble to a hux

pop_table <- as_hux(full_table) %>% 
  set_caption('Population estimates for 2016-2020 (ONS, mid-year estimates) and population projections for 2021-2025, West Sussex.') %>% 
  theme_compact() %>% 
  set_align(everywhere,1,'left') %>% 
  set_align(everywhere,2:11,'right') %>% 
  set_bold(row = 1, col = everywhere) %>% 
  set_background_color(final(19), 2:6, '#CCDFFF') %>% 
  set_background_color(final(19), 7:11, '#88B4FF') %>% 
  set_number_format(final(19),final(10), fmt_pretty())
print(pop_table)
print_latex(pop_table)

quick_latex(pop_table, file = '../JSNA/latex_summary/pop_estimates_and_projections_table.tex', open=FALSE)

# Still not super happy with this approach as I have to comment out a lot of lines from the resulting .tex file!
