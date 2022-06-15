library(tidyverse)
library(ggthemes)
library(hrbrthemes)

# Configure location for source files
source_place <- '~/Documents/JSNA/latex_summary/data_sources/'

# Configure location for saving files
save_place <- '~/Documents/JSNA/latex_summary/images'

requests_data <- tibble(
  year = rep(c(rep('2018/19',2), rep('2019/20',2), rep('2020/21',2)),2),
  location = rep(c('England','West Sussex'),6),
  ageGroup = c(rep('18-64',6), rep('65 and over',6)),
  value=c(1625,1600,1650,1900,1710,1220,13400,9300,13235,12600,12815,8500)
)

admissions_data <- tibble(
  year = rep(c('2006/7','2007/8','2008/9','2009/10','2010/11','2011/12','2012/13','2013/14','2014/15','2015/16','2016/17','2017/18','2018/19','2019/20','2020/21'),2),
  location = c(rep('West Sussex',15),rep('England',15)),
  value = c(636,533,653,597,577,556,937,611,341,353,651,505,582,536,525,799,741,757,712,690,696,697,651,669,628,611,586,580,584,498)
)

indicator_timeperiod <- admissions_data$year %>% unique() %>% sort()
indicator_timeperiod[seq(2,length(indicator_timeperiod),2)] <- ''

admissions_data$year <- factor(admissions_data$year, levels = c('2006/7','2007/8','2008/9','2009/10','2010/11','2011/12','2012/13','2013/14','2014/15','2015/16','2016/17','2017/18','2018/19','2019/20','2020/21'), labels = c('2006/7','2007/8','2008/9','2009/10','2010/11','2011/12','2012/13','2013/14','2014/15','2015/16','2016/17','2017/18','2018/19','2019/20','2020/21'))

plot_18_64 <- ggplot(data = requests_data %>% filter(ageGroup == '18-64'),
                     mapping = aes(x = year, y=value, fill = location)) +
  geom_col(position = position_dodge()) +
  theme_wsj() +
  scale_fill_ft() +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        plot.title.position = 'plot',
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.x = element_text(colour = 'black', size=rel(1)),
        strip.text = element_blank()) +
  labs(x = 'Year',
       caption = 'Source: NHS Digital',
       title = 'Number of requests age 18-64',
       subtitle = 'England and West Sussex per 100,000 population')

print(plot_18_64)
ggsave(plot_18_64, filename = 'sc_requests_18_to_64.png', path = save_place, bg = 'transparent', units = 'mm', width = 235, height = 130)

plot_65_plus <- ggplot(data = requests_data %>% filter(ageGroup == '65 and over'),
                     mapping = aes(x = year, y=value, fill = location)) +
  geom_col(position = position_dodge()) +
  theme_wsj() +
  scale_fill_ft() +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        plot.title.position = 'plot',
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.x = element_text(colour = 'black', size=rel(1)),
        strip.text = element_blank()) +
  labs(x = 'Year',
       caption = 'Source: NHS Digital',
       title = 'Number of requests age 65 and over',
       subtitle = 'England and West Sussex per 100,000 population')

print(plot_65_plus)
ggsave(plot_65_plus, filename = 'sc_requests_over_65.png', path = save_place, bg = 'transparent', units = 'mm', width = 235, height = 130)

# Plot of admissions ####

admissions_plot <- ggplot(data = admissions_data,
                          mapping = aes(x = year, y = value, colour = location, group = location)) +
  geom_line(size=2) +
  geom_point(shape=21, size=2, fill = 'white', stroke = 3) +
  theme_wsj() +
  scale_color_ft() +
  scale_x_discrete(labels = indicator_timeperiod) +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        plot.title.position = 'plot',
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.x = element_text(colour = 'black', size=rel(1)),
        strip.text = element_blank()) +
  labs(x = 'Year',
       caption = 'Source: NHS Digital',
       title = 'Permanent admissions to residential and nursing care homes',
       subtitle = 'England and West Sussex per 100,000 population')

print(admissions_plot)
ggsave(admissions_plot, filename = 'res_care_admissions.png', path = save_place, bg = 'transparent', units = 'mm', width = 235, height = 130)