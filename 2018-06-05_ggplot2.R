# data visualization with ggplot2

# load the data again
surveys <- read.csv("Data/portal_clean.csv")

# load libraries
library(ggplot2)
library(dplyr)

# subset the data to just "DM" species
just_dm <- surveys %>% 
  filter(species_id == "DM")

# average weight and hindfoot length by species
stat_summary <- 
  surveys %>% 
  group_by(species_id) %>% 
  summarize(mean_weight = mean(weight),
            mean_hfl = mean(hindfoot_length),
            n=n())

# year summaries: by year, sex, species_id
year_summary <- 
  surveys %>% 
  group_by(year, species_id, sex) %>% 
  summarize(mean_weight=mean(weight),
            mean_hfl=mean(hindfoot_length),
            n=n())


# Now to a data vis

ggplot(surveys, aes(x=weight, y=hindfoot_length)) +
  geom_point()

# manipulating the objects
p1 <- ggplot(surveys, aes(x=weight, y=hindfoot_length))
p2 <- p1 + geom_point()

# make x-axis on the log scale
p2 + scale_x_log10()
p2 + scale_x_sqrt()

# challenge 6
ggplot(just_dm, aes(x=weight, y=hindfoot_length)) + geom_point()

# challenge 6, variation
surveys %>% filter(species_id=="DM") %>% 
  ggplot(aes(x=weight, y=hindfoot_length)) + geom_point()

# other aesthetics
ggplot(surveys, aes(x=weight, y=hindfoot_length)) +
  geom_point(alpha=0.2)

ggplot(surveys, aes(x=weight, y=hindfoot_length)) +
  geom_point(color="slateblue")

ggplot(surveys, aes(x=weight, y=hindfoot_length)) +
  geom_point(size=0.6, color="slateblue", alpha=0.2)

# color by species
ggplot(surveys, aes(x=weight, y=hindfoot_length)) +
  geom_point(size=0.6, alpha=0.2, aes(color=species_id))

stat_summary <- surveys %>% group_by(species_id) %>%
  summarize(mean_wt = mean(weight),
    mean_hfl = mean(hindfoot_length),
    n = n())

# challenge 7
ggplot(stat_summary, aes(x=mean_wt, y=mean_hfl)) + 
  geom_point(aes(size=n))

# female DM summaries by year
dm_female_by_year <- year_summary %>% 
  filter(species_id=="DM", sex=="F")

# plot sample size by year
ggplot(dm_female_by_year, aes(x=year, y=n)) + 
  geom_line()

# both points and lines
ggplot(dm_female_by_year, aes(x=year, y=n)) + 
  geom_point(aes(color=year)) +
  geom_line(color="violetred")

ggplot(dm_female_by_year, aes(x=year, y=n)) + 
  geom_point() +
  geom_line() +
  aes(color=year)

# year summary data
year_summary <- 
  surveys %>% group_by(year, species_id, sex) %>% 
  summarize(mean_wt=mean(weight),
            mean_hfl=mean(hindfoot_length),
            n=n())

# challenge 8
ggplot(year_summary, aes(x=year, y=n)) +
  geom_line(aes(linetype=sex, color = species_id))

# faceting
ggplot(year_summary, aes(x=year, y=n)) +
  geom_line(aes(linetype=sex)) +
  facet_wrap( ~ species_id)

# filter down to the D- species
d_counts <- year_summary %>% 
  filter(species_id %in% c("DM", "DS", "DO"))

# facet_grid
ggplot(d_counts, aes(x=year, y=n)) +
  geom_line(aes(linetype=sex)) +
  facet_grid(~ species_id)

# split the other way
ggplot(d_counts, aes(x=year, y=n)) +
  geom_line(aes(linetype=sex)) +
  facet_grid(species_id ~ .)

# split both ways on two columns
ggplot(d_counts, aes(x=year, y=n)) +
  geom_line(aes(linetype=sex)) +
  facet_grid(species_id ~ sex)


ggplot(d_counts, aes(x=year, y=n)) +
  geom_line(aes(linetype=sex)) +
  facet_grid(species_id ~ sex) +
  theme_bw()

ggplot(d_counts, aes(x=year, y=n)) +
  geom_line(aes(linetype=sex)) +
  facet_grid(species_id ~ sex) +
  theme_karl()

# some univariate plots
# histogram
ggplot(surveys, aes(x=hindfoot_length)) +
  geom_histogram() + facet_grid(sex~.)

# boxplot
ggplot(surveys, aes(x=species_id, y=hindfoot_length)) +
  geom_boxplot() + 
  geom_jitter(alpha=0.1, color="pink", width=0.1, height=0)

# save a plot to a file
p <- ggplot(surveys, aes(x=weight, y=hindfoot_length)) + 
  geom_point()
ggsave("Figs/scatter.png", p, height=6, width=8)











  
  











