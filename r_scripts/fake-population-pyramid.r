# Let us create an abomination! A population pyramid with stacked bars!!

# We're going to have males and females, and a proportion of each gender who play pokemon go

# Need the tidyverse because ggplot and tibble

library(tidymodels)

# Now set up our fake data set
# It uses runif() so we'll set a seed too
set.seed(123)

fake_data <- tibble(
  sex = c(rep('Male',4),rep('Female',4)),
  age = rep(c('<16','16-19','20-24','25+'),2),
  population = runif(8, 1000, 2000) %>% round(),
  pokemon_prop = runif(8),
  pokemon_players = (pokemon_prop*population) %>% round(), # the beauty of tibble!
  non_poke_players = population - pokemon_players
)

# because we are trying avoid extra packages we need to get data how we want
# It's still a bar graph, just need the values for females to point in a different direction to males

fake_data_pyramid <- fake_data %>% 
  mutate(pokemon_players_pyr = ifelse(sex == 'Male', pokemon_players, -pokemon_players),
         non_poke_players_pyr = ifelse(sex == 'Male', non_poke_players, -non_poke_players))

# Next we need to pivot the data to get it ready for plotting
fake_data_pyramid_2 <- fake_data_pyramid %>% 
  select(all_of(c('sex','age','pokemon_players_pyr','non_poke_players_pyr'))) %>% 
  pivot_longer(cols = ends_with('_pyr'), names_to = 'play_poke', values_to = 'value') %>% 
  mutate(play_poke = ifelse(play_poke == 'pokemon_players_pyr', 'Player', 'Non-Player'))

# But we want sex and play_poke to be one column for our pyramid so we need to unite those two columns
fake_data_pyramid_3 <- fake_data_pyramid_2 %>% 
  mutate(pyramid_fill = paste(sex,play_poke))


# Right a really rough first go

fake_pyramid <- ggplot(
  data = fake_data_pyramid_3,
  mapping = aes(
    x = value,
    y = age,
    fill = pyramid_fill
  )
) + geom_bar(stat = 'identity', position = 'stack')

fake_pyramid

# A pretty good start
# Things we now need to do
# 1. Turn our pyramid fill parameter into a factor. We need to order it so that it definitely puts the players on the insides of the margin each time (we kind of fluked this)
# 2. We want to annotate the plot with 'Males' on the right and 'Females' on the left
# 3. Then we can choose a colour palette that has two values for players and non-players
# 4. Adjust the labels - we don't really have negative women - this is just a matter of changing the labels 
# 5. Introduce a discontinuity at zero to more clearly distinguish males and females - unfortunately we can't do this in ggplot, but we might be able to run an axis right up the middle

