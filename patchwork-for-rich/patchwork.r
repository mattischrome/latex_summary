library(tidyverse)
library(patchwork)
library(gridtext)

# Grab the individual plots for cancer screening programmes
# plot all six on a single page using the patchwork package

# Bonus points if I can get descriptive text worked in as well

# setwd('~/Documents/JSNA/latex_summary/r_scripts/')

# This source of the code is slow and includes redundant lines

# TODO: Need to build a version that pulls down the data we need in one go and builds the appropriate plots

# TODO: the line charts have an issue with their y-axis label that seems to be pulled as far from the y axis as possible, so will need to fix that to make things work with Patchwork

source('./03-cervical-cancer.R') # cerv_plot
source('./03-cervical-cancer-rag.R') # cerv_rag
source('./03-breast-cancer.R') # breast_plot
source('./03-breast-cancer-rag.R') # breast_rag
source('./03-bowel-cancer.R') # bowel_plot
source('./03-bowel-cancer-rag.R') # bowel_rag

# Now some text grobs
# TODO: We use the previous JSNA summary text as a placeholder, will need to update this text
# TODO: Better managment of the source strings is needed so that we can dynamically insert the figures from data.

# gridtext::textboxgrob lets us wrap sentences as needed
# TODO: Pad the text boxes for better aesthetics 
# TODO: Justify text boxes to top left

wrap_width = 40
cerv_text <- str_wrap('The screening rate at county level for **cervical cancer (in women aged 25-49 years) is 73.5%** (Crawley, 67.6%). Uptake has been at a 20-year low, although two promotional campaigns may have contributed to increased coverage in 2019.', wrap_width)
cerv_text_grob <- textbox_grob(text = cerv_text)
breast_text <- str_wrap('The screening rate at county level for **breast cancer (in women aged 25-49 years) is 74.9%** (Crawley, 70.3%). Recent issues with the West Sussex breast programme\'s round length may explain the decline in screening coverage.', wrap_width)
breast_text_grob <- textbox_grob(text = breast_text)
bowel_text <- str_wrap('The screening rate at county-level for **bowel cancer is 63.1%** (Crawley, 55%).', wrap_width)
bowel_text_grob <- textbox_grob(text = bowel_text)

cerv_plot_with_text <- cerv_plot / cerv_text_grob
breast_plot_with_text <- breast_plot / breast_text_grob
bowel_plot_with_text <- bowel_plot / bowel_text_grob

# screening_page <- (cerv_rag + breast_rag + bowel_rag) / ((cerv_plot / cerv_text_grob) + (breast_plot/breast_text_grob) + (bowel_plot / bowel_text_grob))
screening_page <- cerv_rag + breast_rag + bowel_rag + cerv_plot_with_text + breast_plot_with_text + bowel_plot_with_text
# cerv_plot/cerv_text_grob
print(screening_page)
