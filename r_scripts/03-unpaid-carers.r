library(tidyverse)
library(ggthemes)
library(hrbrthemes)

data_place <- '~/Documents/JSNA/latex_summary/data_sources/'
save_place <- '~/Documents/JSNA/latex_summary/images/'

# Census table
unpaid_carer_data <- read_csv(paste0(data_place,'wsx_dabs_carers_age_sex_2011_census_simple.csv'))

# 2011 Population figures
population_data_2011 <- read_csv(paste0(data_place,'wsx_dabs_2011_census_popn_care_agebands.csv'))

area_cols <- c('West Sussex','Adur','Arun','Chichester','Crawley','Horsham','Mid Sussex','Worthing')

pop_11_tall <- population_data_2011 %>% pivot_longer(cols = all_of(area_cols), names_to = "Area") %>% rename(`Age Group` = `Age`,Population = value)

# 2020 Population estimates to apply proportions to
population_data_2020 <- read_csv(paste0(data_place,'wsx_dabs_2020_pop_ests_carer_agebands.csv'))

pop_20_tall <- population_data_2020 %>% pivot_longer(cols = all_of(area_cols), names_to = "Area") %>% rename(New.Population = value)

# %>% 
#   mutate(prop_0_24 = `Age 0 to 24`/Total,
#          prop_25_49 = `Age 25 to 49`/Total,
#          prop_50_64 = `Age 50 to 64`/Total,
#          prop_65_over = `Age 65 and over`/Total)

age_cols <- c("Total", "Age 0 to 24", "Age 25 to 49", "Age 50 to 64", "Age 65 and over")

upcd_tall <- unpaid_carer_data %>% pivot_longer(cols = all_of(age_cols), names_to = "Age Group") %>% mutate(Area = str_replace(Area,"uacounty09:",""),                                        Area = str_replace(Area,"ualad09:",""))

# proportion not a carer = 1 - proportion a carer, so only need one state
upcd_to_join <- upcd_tall %>% filter(Carer == 'Provides unpaid care: Total') %>% 
  select(-Carer) %>% 
  rename(Carers = value)

joined_data <- full_join(upcd_to_join,pop_11_tall)
joined_data_2 <- full_join(joined_data,pop_20_tall)

new_carers_data <- joined_data_2 %>% mutate(New.Carers = (Carers/Population)*New.Population)

plot_carers_data_f <- new_carers_data %>%
  filter(Area != 'West Sussex') %>% 
  filter(Sex == 'Females') %>% 
  filter(`Age Group` != 'Total')

unpaid_carers_plot_f <- ggplot(data = plot_carers_data_f,
                                 mapping = aes(x = Area, y = New.Carers, group = `Age Group`, fill = `Age Group`)) +
  geom_col(position = position_dodge()) +
  theme_wsj() +
  scale_fill_ft() +
  expand_limits(y=c(0,5000)) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y = 'Estimated number of unpaid carers')

print(unpaid_carers_plot_f)

plot_carers_data_m <- new_carers_data %>%
  filter(Area != 'West Sussex') %>% 
  filter(Sex == 'Males') %>% 
  filter(`Age Group` != 'Total')

unpaid_carers_plot_m <- ggplot(data = plot_carers_data_m,
                               mapping = aes(x = Area, y = New.Carers, group = `Age Group`, fill = `Age Group`)) +
  geom_col(position = position_dodge()) +
  theme_wsj() +
  scale_fill_ft() +
  expand_limits(y=c(0,5000)) +
  theme(legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y = 'Estimated number of unpaid carers')

print(unpaid_carers_plot_m)

# Now a plot of M/F split
plot_carers_data_age <- new_carers_data %>%
  filter(Area == 'West Sussex') %>% 
  filter(Sex != 'All persons') %>% 
  filter(`Age Group` != 'Total')

unpaid_carers_plot_age <- ggplot(data = plot_carers_data_age,
                                 mapping = aes(x=`Age Group`, y = New.Carers, group = Sex, fill = Sex))+
  geom_col()+
  theme_wsj() +
  scale_fill_ft() +
  expand_limits(y=c(0,40000)) +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y = 'Estimated number of unpaid carers')

print(unpaid_carers_plot_age)

ggsave(unpaid_carers_plot_f, filename = 'female_unpaid_carers.png', path = save_place, bg = 'transparent', units = 'mm', width = 220, height = 110)
ggsave(unpaid_carers_plot_m, filename = 'male_unpaid_carers.png', path = save_place, bg = 'transparent', units = 'mm', width = 220, height = 110)
ggsave(unpaid_carers_plot_age, filename = 'wsx_unpaid_carers_by_age.png', path = save_place, bg = 'transparent', units = 'mm', width = 235, height = 130)
