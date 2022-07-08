# 01-overall.r 
# Script generating figures for chapter 1 of the West Sussex JSNA summary

# Packages
library(tidyverse)
library(hrbrthemes)
library(fingertipsR)
library(ggthemes)
library(ggtext)

# Configure location for source files
source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images'

# Fingertips-y stuff
inds <- indicators()
inds_sh <- inds[grep('self-harm',inds$IndicatorName),]

# NB this was data collected for the Self-harm rapid needs assessment