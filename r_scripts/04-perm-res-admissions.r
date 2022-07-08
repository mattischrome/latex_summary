library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- '~/Documents/Projects/JSNA/latex_summary/data_sources/'

save_place <- '~/Documents/Projects/JSNA/latex_summary/images/'

# Permanent admissions to care homes
the_data <- tibble(
  date = c("2006/07", "2006/07", "2007/08", "2007/08", "2008/09", "2008/09", "2009/10", "2009/10", "2010/11", "2010/11", "2011/12", "2011/12", "2012/13", "2012/13", "2013/14", "2013/14", "2014/15", "2014/15", "2015/16", "2015/16", "2016/17", "2016/17", "2017/18", "2017/18", "2018/19", "2018/19", "2019/20", "2019/20", "2020/21", "2020/21"),
  location = rep(c("West Sussex","England"),15),
  value = c(636, 799, 533, 741, 653, 757, 597, 712, 577, 690, 556, 696, 937, 697, 611, 651, 341, 669, 353, 628, 651, 611, 505, 586, 582, 580, 536, 584, 525, 498)
)

indicator_timeperiod <- the_data$date %>% unique()
indicator_timeperiod[seq(2,length(indicator_timeperiod),2)] <- ''

the_plot <- ggplot(
  data = the_data,
  mapping = aes(x = date, y=value, group=location, color=location)
) +
  geom_line(size=2) +
  geom_point(shape=21, size=3, fill = 'white', stroke = 3) +
  scale_x_discrete(labels = indicator_timeperiod) +
  theme_wsj() +
  scale_color_ft() +
  expand_limits(y=c(200,1000)) +
  theme(legend.position = c(.8,.1),
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        title = element_text(family = "sans", size = rel(1)),
        rect = element_rect(fill = 'transparent', linetype = 0, colour = NA),
        axis.title.y = element_text(colour = 'black', size=rel(1))) +
  labs(y='People aged 65 and over',
       caption = 'Large fluctuations in this metric may indicate a data recording issue.')

print(the_plot)
ggsave(paste0(save_place,"perm_res_adm_time.png"),the_plot,width=180,height=90,units="mm",dpi="print")
