# 02-gp-prac-staff.r
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

mar_22_gp_staff <- read_csv(paste0(source_place,"/mar_22_gp_practice_level.csv"))

table_cols <- c("TOTAL_ADMIN_FTE", "TOTAL_ADMIN_HC", "TOTAL_DPC_FTE", "TOTAL_DPC_HC", "TOTAL_NURSES_FTE", "TOTAL_NURSES_HC", "TOTAL_GP_FTE", "TOTAL_GP_HC", "TOTAL_GP_EXTGL_FTE", "TOTAL_GP_EXTGL_HC", "TOTAL_GP_EXTG_FTE", "TOTAL_GP_EXTG_HC")

table_labels <- c("Admin / Non-clinical",
                  "Direct patient care staff",
                  "Nurses",
                  "All GPs",
                  "Qualified Permanent GPs (excludes Registrars and Locums)", 
                  "Fully qualified GPs (excludes Registrars)")

mar_22_gp_staff_wsx <- mar_22_gp_staff %>% 
  filter(`CCG_NAME` == "NHS West Sussex CCG") %>% 
  select(all_of(c("PRAC_NAME",table_cols))) %>% 
  mutate_at(table_cols, as.numeric) %>% 
  summarise_at(table_cols, sum, na.rm = TRUE)

age_under_55 <- c("TOTAL_GP_HC_UNDER30",
                  "TOTAL_GP_HC_30TO34",
                  "TOTAL_GP_HC_35TO39",
                  "TOTAL_GP_HC_40TO44",
                  "TOTAL_GP_HC_45TO49",
                  "TOTAL_GP_HC_50TO54")
age_over_55 <- c("TOTAL_GP_HC_55TO59",
                 "TOTAL_GP_HC_60TO64",
                 "TOTAL_GP_HC_65TO69",
                 "TOTAL_GP_HC_70PLUS")

mar_22_gp_staff_wsx_u55 <- mar_22_gp_staff %>% 
  filter(`CCG_NAME` == "NHS West Sussex CCG") %>% 
  select(all_of(c("PRAC_NAME",age_under_55))) %>% 
  mutate_at(age_under_55, as.numeric) %>% 
  summarise_at(age_under_55, sum, na.rm = TRUE)
  
mar_22_gp_staff_wsx_o55 <- mar_22_gp_staff %>% 
    filter(`CCG_NAME` == "NHS West Sussex CCG") %>% 
    select(all_of(c("PRAC_NAME",age_over_55))) %>% 
             mutate_at(age_over_55, as.numeric) %>% 
             summarise_at(age_over_55, sum, na.rm = TRUE)
