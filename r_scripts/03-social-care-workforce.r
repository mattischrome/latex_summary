# Social care gauge charts - just for visual fun
library(tidyverse)
library(patchwork)

save_place <- '~/Documents/JSNA/latex_summary/images/'

gg.gauge <- function(pos,the_title,the_subtitle,breaks=c(0,30,70,100)) {
  require(ggplot2)
  get.poly <- function(a,b,r1=0.5,r2=1.0) {
    th.start <- pi*(1-a/100)
    th.end   <- pi*(1-b/100)
    th       <- seq(th.start,th.end,length=100)
    x        <- c(r1*cos(th),rev(r2*cos(th)))
    y        <- c(r1*sin(th),rev(r2*sin(th)))
    return(data.frame(x,y))
  }
  ggplot()+ 
    geom_polygon(data=get.poly(breaks[1],breaks[2]),aes(x,y),fill="lightsteelblue1")+
    geom_polygon(data=get.poly(breaks[2],breaks[3]),aes(x,y),fill="lightsteelblue2")+
    geom_polygon(data=get.poly(breaks[3],breaks[4]),aes(x,y),fill="lightsteelblue3")+
    geom_polygon(data=get.poly(pos-1,pos+1,0.2),aes(x,y))+
    geom_text(data=as.data.frame(breaks), size=5, fontface="bold", vjust=0,
              aes(x=0.9*cos(pi*(1-breaks/100)),y=1.1*sin(pi*(1-breaks/100)),label=paste0(breaks,"%")))+
    annotate("text",x=0,y=0,label=pos,vjust=0,size=8,fontface="bold")+
    coord_fixed()+
    theme_bw()+
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank(),
          panel.grid=element_blank(),
          panel.border=element_blank(),
          plot.title=element_text(face='bold'))+
    labs(title = the_title,
         subtitle = the_subtitle)
}



dial_1 <- gg.gauge(6,'Vacancy rate\n\n','The vacancy rate in\n2020/21 equated to\n1,410 jobs\n')
dial_2 <- gg.gauge(33,'Turnover rate\n\n','The rate in 2020/21\nequated to 7,800\nleavers\n')
dial_3 <- gg.gauge(63,'Percentage of staff\nremaining in same\nsector','')

all_the_dials <- dial_1 + dial_2 + dial_3

# +
#   plot_annotation(title = 'A bunch of dial charts',
#                   subtitle = 'West Sussex, 2021')

print(all_the_dials)
ggsave(paste0(save_place,'workforce_dial_chart.png'), plot = all_the_dials, width = 30, height = 10, units = 'cm', dpi = 'print')
