# dplyr 2018-08-27

library(dplyr)  # load dplyr package

# load the data
surveys <- read.csv("https://kbroman.org/datacarp/portal_clean.csv")
head(surveys)

# select function - select a set of columns from a data frame
selected_col <- select(surveys, year, species_id, weight)
head(selected_col)

# filter function - filtering a set of rows from a data frame
year1995 <- filter(selected_col, year == 1995)
head(year1995)

# filter with multiple conditions
year1995_and_heavy <- filter(selected_col, year==1995, weight > 100)
head(year1995_and_heavy)

# filter with an or (single vertical bar in R)
year1995_or_heavy <- filter(selected_col, year==1995 | weight > 100)
nrow(year1995_or_heavy)

# pipe operator
year1995 <- filter(surveys, year==1995) %>% 
    select(year, species_id, weight)
head(year1995)

# challenge 1
chal1 <- surveys %>% 
    filter(weight < 5) %>% 
    select(year, sex, weight)

# mutate - add a new column to a dataframe
surveys_w_kg_weight <- surveys %>% mutate(weight_kg = weight/1000)
colnames(surveys_w_kg_weight) # column names

# challenge 2
chal2 <- surveys %>% 
    mutate(hindfoot_sqrt = sqrt(hindfoot_length)) %>% 
    filter(hindfoot_sqrt < 3) %>% 
    select(species_id, hindfoot_sqrt)
    
chal2a <- mutate(surveys, hindfoot_sqrt=sqrt(hindfoot_length))
chal2b <- filter(chal2a, hindfoot_sqrt < 3)
chal2c <- select(chal2b, species_id, hindfoot_sqrt)

surveys %>% mutate(hindfoot_sqrt = sqrt(hindfoot_length)) %>% 
    filter(hindfoot_sqrt < 3) %>% 
    select(species_id, hindfoot_sqrt)

# group by to calculate mean weight by sex
surveys %>% group_by(sex) %>% 
    summarize(mean_weight = mean(weight))

# group by to calculate sample sizes by sex
surveys %>% group_by(sex) %>% 
    summarize(sample_size = n())

# get both of those summaries
surveys %>% group_by(sex) %>% 
    summarize(mean_weight=mean(weight), sample_size=n())

# group by multiple columns and sort by weight
surveys %>% group_by(sex, species_id) %>% 
    summarize(mean_weight=mean(weight)) %>% 
    arrange(mean_weight)

surveys %>% group_by(sex, species_id) %>% 
    summarize(mean_weight=mean(weight), min_weight=min(weight),
              max_weight=max(weight)) %>% 
    arrange(desc(mean_weight))

# counts by plot_type
surveys %>% group_by(plot_type) %>% 
    summarize(sample_size=n())

surveys %>% group_by(plot_type) %>% 
    tally()

