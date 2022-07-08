# 02-frs-disability.r

# A table for disability prevalence applied to West Sussex Population

# Population pyramid showing disability by age group and gender

# Packages
library(tidyverse)
library(hrbrthemes)
library(ggthemes)
library(ggtext)

# Configure location for source files
source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/Projects/JSNA/latex_summary/images'

# West Sussex Population estimates 2020 by 5 year age bands (Nomis)
wsx_2020_mye <- read_csv(paste0(source_place,'WSX_2020_MYE_5yab.csv'))

# FRS disability prevalence estimates by age and gender, average of 2017/18, 2018/19, and 2019/20
frs_disab_prev <- read_csv(paste0(source_place,'FRS_disability_props.csv'))

cols_to_pivot <- setdiff(names(frs_disab_prev),'Age')

# Need to align age groups
wsx_eighty_plus <- wsx_2020_mye %>% 
  filter(Age %in% c('80-84','85+')) %>% 
  select(-Age) %>% 
  mutate(Age = '80+') %>% 
  group_by(Age) %>% 
  summarise(Male = sum(Male), Female = sum(Female), Total = sum(Total))

ages_we_want = setdiff(wsx_2020_mye$Age,c('80-84','85+'))
wsx_2020_mye_frs_aligned <- wsx_2020_mye %>% 
  filter(Age %in% ages_we_want) %>% 
  rbind(wsx_eighty_plus)

# Apply the proportions to our population
smoosh <- wsx_2020_mye_frs_aligned %>% select(-Total)
smoosh_2 <- left_join(frs_disab_prev %>% filter(Age != 'Total'),smoosh, by='Age') %>% 
  mutate(wsx_male_disabled = round(Male * `Male disabled`),
         wsx_male_nondisabled = round(Male * `Male not disabled`),
         wsx_female_disabled = round(Female * `Female disabled`),
         wsx_female_nondisabled = round(Female * `Female not disabled`))

frs_disab_wsx <- smoosh_2 %>% 
  select(Age, starts_with('wsx')) %>%  # select the columns we need
  pivot_longer(cols = starts_with('wsx'), names_to = 'pyramid_fill') %>%  # Pivot those columns in to one column fill
  separate(col = pyramid_fill, into = c('wsx','sex','disability_status'), sep = '_', remove = FALSE) %>%  # Give us data on sex and disability status
  select(-wsx) %>%  # Drop the wsx column
  mutate(value = ifelse(sex=='male',-value,value)) %>%  # Put male values on the LHS
  mutate(disability_status = ifelse(disability_status=='disabled','Disabled','Not disabled'))

age_levels <- frs_disab_wsx$Age %>% unique()
age_labels <- paste0(age_levels, ' years')
frs_disab_wsx$Age <- factor(frs_disab_wsx$Age, levels = age_levels, labels = age_labels)

# Pyramid time

frs_pyramid <- ggplot(
  data = frs_disab_wsx,
  mapping = aes(
    x = value,
    y = Age,
    fill = disability_status
  )
) + geom_bar(stat = 'identity', position = 'stack') +
  geom_vline(xintercept = 0) +
  geom_richtext(x=33000,y=4.5,label = '**Females**',stat='unique',color='black',fill=NA,label.color=NA,size=rel(4)) +
  geom_richtext(x=-35000,y=4.5,label = '**Males**',stat='unique',color='black',fill=NA,label.color=NA,size=rel(4)) +
  expand_limits(x=c(-37000,37000)) +
  theme_wsj() +
  scale_fill_manual(values = c('#617a89', '#0b53c1','#617a89', '#0b53c1')) +
  scale_x_continuous(label=abs) +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.x = element_text(colour = 'black', size=rel(1), hjust=1)) +
  labs(
    y = '',
    x = 'People')

print(frs_pyramid)

ggsave(frs_pyramid, filename = 'frs_disability_wsx.png', path = save_place, bg = 'transparent', units = 'mm', width = 135, height = 135)
