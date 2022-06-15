# 02-nhs-staff.r

# Should be a simpler set of tables now that West Sussex has just one CCG

# Packages
library(tidyverse)
library(huxtable)
# library(hrbrthemes)
# library(ggthemes)
# library(ggtext)

# Configure location for source files
source_place <- '~/Documents/JSNA/latex_summary/data_sources/NHS workforce'

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images'

jan_22_med_staff <- read_csv(paste0(source_place,"/jan-22-medical-staff.csv"))
jan_22_non_medical_staff <- read_csv(paste0(source_place, "/jan-22-non-medical-staff.csv"))
jan_22_staff_group_and_nhse_region <- read_csv(paste0(source_place, "/jan-22-staff-group-and-nhse-region.csv"))
jan_22_staff_group_and_organisation <- read_csv(paste0(source_place, "/jan-22-staff-group-and-organisation.csv"))

jan_22_med_staff_wsx <- jan_22_med_staff %>% 
  filter(`Org name` == "NHS West Sussex CCG")
jan_22_non_medical_staff_wsx <- jan_22_non_medical_staff %>% 
  filter(`Org name` == "NHS West Sussex CCG")
jan_22_staff_group_and_nhse_region_wsx <- jan_22_staff_group_and_nhse_region %>% 
  filter(`NHSE_Region_Name` == "South East")
jan_22_staff_group_and_organisation_wsx <- jan_22_staff_group_and_organisation %>% 
  filter(`Org Name` == "NHS West Sussex CCG")
