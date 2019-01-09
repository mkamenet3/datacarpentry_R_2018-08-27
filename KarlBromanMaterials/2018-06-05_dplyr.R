# dplyr tutorial

# load the dplyr package
library(dplyr)

# load the surveys data that we got from 
#   http://kbroman.org/datacarp/portal_clean.csv
surveys <- read.csv("Data/portal_clean.csv")

# first few rows of that object
head(surveys)

# select to grab some columns
selected_col <- select(surveys, species_id, year, weight)
head(selected_col)

# filter out just rows for year 1995
surveys1995 <- filter(selected_col, year == 1995)
head(surveys1995)

# pipe operator
surveys %>% 
  filter(year == 1995) %>% 
  select(species_id, year, weight) %>% 
  head()

# challenge 1
surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight)

# challenge 1 variation - works fine
surveys %>% 
  filter(species_id == "DM") %>% 
  select(year, sex, weight)

# challenge 1 variation #2 - won't work
surveys %>% 
  select(year, sex, weight) %>% 
  filter(species_id == "DM")

# mutate
surveys_with_kg_weight <-
  surveys %>% 
  mutate(weight_kg = weight/1000)

# look at str() of new data vs original
str(surveys)
str(surveys_with_kg_weight)

# Challenge 2
challenge2 <- surveys %>% 
  mutate(hindfoot_sqrt = sqrt(hindfoot_length)) %>% 
  filter(hindfoot_sqrt < 3) %>% 
  select(species_id, hindfoot_sqrt)

# count the number of subjects for each sex
surveys %>% 
  group_by(sex) %>% 
  summarize(n = n())

# can also use tally()
surveys %>% 
  group_by(sex) %>% 
  tally()

# what's the average weight for each sex?
surveys %>% 
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight))

# split on sex and species_id
mean_wt_by_sex_species <- surveys %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight))
as.data.frame(mean_wt_by_sex_species)

# can grab multiple summaries
surveys %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight), 
            mean_hindfoot = mean(hindfoot_length),
            sample_size = n())
# and sort the results
surveys %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight),
            sample_size = n()) %>% 
  arrange(desc(mean_weight))