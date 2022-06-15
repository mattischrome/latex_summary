# Data for common mental health disorder prevalences applied 
# to West Sussex.

library(tidyverse)

cmhd_table <- tibble(
  Condition = c(rep("Generalised anxiety disorder",8),
              rep("Depressive episode",8),
              rep("Phobias", 8),
              rep("Obsessive compulsive disorder",8),
              rep("Panic disorder",8),
              rep("CMD-NOS (not otherwise specified)",8),
              rep("Any CMD",8)),
  AgeGroup = rep(c("16-24", "25-34", "35-44", "45-54", "55-64", "65-74", "75+", "All"),7),
  Value = c(4780,5540,7250,9050,6700,3990,2260,40750,
            1750,3180,4310,5580,4500,2090,1180,22800,
            2510,3000,3150,3350,2410,600,450,16580,
            1370,1270,1680,1980,1570,300,270,8980,
            910,450,320,620,520,700,540,4140,
            6380,8270,8610,10790,8480,5190,4430,53880,
            14350,17270,20270,263690,18850,11470,7950,117430))
