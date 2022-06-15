# 02-ypll-figure.r

library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(ggtext)

source_place <- "~/Documents/JSNA/latex_summary/data_sources/"
save_place <- "~/Documents/JSNA/latex_summary/images"

ypll_u75_all <- read_csv(paste0(source_place, "ypll_u75_wsx_pcns.csv"))
plot_meta <- tibble(
  label = c("West Sussex",
            "Arun (ACF)",
            "Arun (AIC)",
            "Burgess Hill & Villages",
            "Central Worthing",
            "Chanctonbury",
            "CHAMP",
            "Cissbury Integrated Care (CIC)",
            "Coastal & South Downs Care",
            "Crawley Care Collaborative",
            "East Grinstead",
            "Haywards Heath Central",
            "Haywards Health Villages",
            "Healthy Crawley",
            "Horsham Central",
            "Horsham Collaborative",
            "Lancing",
            "Regis Healthcare",
            "Rural North Chichester",
            "Shoreham",
            "South Crawley"),
  label_order = c(1, 5, 4, 18, 10, 6, 7,
                  12, 11, 13, 19, 20, 21,
                  14, 16, 17, 3, 9, 8, 2, 15))

ypll_u75_to_plot <- cbind(ypll_u75_all, plot_meta)

ypll_u75_to_plot$label <- factor(ypll_u75_to_plot$label)
ypll_u75_to_plot$label <- reorder(ypll_u75_to_plot$label,
  21 - ypll_u75_to_plot$label_order)

ypll_u75_to_plot <- ypll_u75_to_plot %>%
  mutate(is_higher = ifelse(ypll_u75_all$lower > 389.07, TRUE, FALSE))

the_caption <- "Rate excludes persons who were not registered to a GP
   at time of death. Red bars indicate PCNs with significantly higher
   rate than West Sussex. GPs are included in their current PCN for all
   pooled years. Closed practices were assigned to their PCN at time of
   closure."
wrapped_caption <- the_caption %>% str_wrap(70)

the_plot <- ggplot(data = ypll_u75_to_plot,
                   mapping = aes(x = label, y = rate, fill = is_higher)) +
  geom_col() +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.2) +
  geom_richtext(aes(label = round(rate, digits = 1)),
                    color = "white",
                    fill = NA,
                    label.color = NA,
                    nudge_y = -8,
                    size = rel(4),
                    na.rm = TRUE,
                    hjust = 1,
                    vjust = 0.5) +
  coord_flip() +
  theme_wsj(base_size = 10, base_family = "sans", title_family = "sans") +
  scale_fill_manual(values = c("#617a89", "#ff0055")) +
  labs(
    title = "Years of Potential Life Lost\nRate per 10,000 Population (U75)",
    subtitle = "Pooled Data of Deaths Registered 2017-21, West Sussex PCNs",
    y = "Rate of YPLL per 10,000 Population",
    caption = wrapped_caption
  ) +
  theme(legend.position = "none",
        legend.title = element_blank(),
        legend.text = element_text(size = rel(1)),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        plot.title = element_text(family = "sans", size = rel(0.7)),
        plot.subtitle = element_text(family = "sans", size = rel(0.6)),
        plot.caption = element_text(family = "sans",
                                    size = rel(0.6),
                                    hjust = 0),
        axis.text.x = element_text(family = "sans"),
        rect = element_rect(fill = "transparent",
                            linetype = 0,
                            colour = NA),
        axis.title.x = element_text(colour = "black",
                                    size = rel(0.5)))

the_plot

ggsave(the_plot,
  filename = "ypll_by_pcn.png",
  path = save_place,
  bg = "transparent",
  units = "mm",
  width = 140,
  height = 180)
