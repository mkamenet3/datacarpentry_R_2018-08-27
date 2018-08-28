# data visualization with ggplot2

library(dplyr)
library(ggplot2)
surveys <- read.csv("https://kbroman.org/datacarp/portal_clean.csv")

# three data sets 
# just_dm containing only the observations with species_id == "DM"
just_dm <- surveys %>% filter(species_id=="DM")

# stat_summary average weight and hindfoot length for each species + count
stat_summary <- surveys %>% group_by(species_id) %>% 
    summarize(mean_wt = mean(weight),
              mean_hfl = mean(hindfoot_length),
              n = n())

# year_summary = average weight, hindfoot_length, and sample size
#  by year, species, and sex
stat_summary <- surveys %>% group_by(species_id, year, sex) %>% 
    summarize(mean_wt = mean(weight),
              mean_hfl = mean(hindfoot_length),
              n = n())

#### now to the data vis bit
ggplot(surveys, aes(x=weight, y=hindfoot_length)) +
    geom_point()

# ggplot function makes graphical objects
p1 <- ggplot(surveys, aes(x=weight, y=hindfoot_length))
# + symbol adds/modifies the object
p2 <- p1 + geom_point()
# here I'm making the x axis on the log scale
# parentheses are a trick to both assign and "print"
( p3 <- p2 + scale_x_log10() )

# challenge 6
just_dm %>% ggplot(aes(x=weight, y=hindfoot_length)) +
    geom_point()

# other aesthetics
ggplot(surveys, aes(x=weight, y=hindfoot_length)) +
    geom_point(alpha=0.1, color="slateblue")

ggplot(surveys, aes(x=weight, y=hindfoot_length)) +
    geom_point(alpha=0.1, aes(color=species_id))

# challenge 7
stat_summary <- surveys %>% group_by(species_id) %>% 
    summarize(mean_wt=mean(weight),
              mean_hfl=mean(hindfoot_length),
              n=n())

ggplot(stat_summary, aes(x=mean_wt, y=mean_hfl)) +
    geom_point(aes(size=n))


# line plot of sample size by year
count_by_year <- surveys %>% group_by(year) %>% tally()

ggplot(count_by_year, aes(x=year, y=n)) +
    geom_line()

# layers
ggplot(count_by_year, aes(x=year, y=n)) +
    geom_line() + geom_point(color="slateblue")

ggplot(count_by_year, aes(x=year, y=n)) +
    geom_point(aes(color=year)) +
    geom_line()

ggplot(count_by_year, aes(x=year, y=n, color=year)) +
    geom_point() +
    geom_line()

ggplot(count_by_year, aes(x=year, y=n)) +
    geom_point() +
    geom_line() +
    aes(color=year)

# challenge 8

year_summary <- surveys %>% 
    group_by(species_id, year, sex) %>% 
    summarize(mean_wt=mean(weight),
              mean_hfl=mean(hindfoot_length),
              n=n())
ggplot(year_summary, aes(x=year, y=n)) +
    geom_line() + aes(color=species_id, linetype=sex)

year_summary %>% filter(species_id %in% c("DM", "DS")) %>% 
ggplot(aes(x=year, y=n)) +
    geom_line(aes(color=species_id, linetype=sex))

# facet wrap: subpanels by species id, wrapping around
ggplot(year_summary, aes(x=year, y=n)) +
    geom_line(aes(color=sex)) +
    facet_wrap( ~ species_id)

# facet grid
d_counts <- year_summary %>% 
    filter(species_id %in% c("DM", "DS", "DO"))
# split horizontally
ggplot(d_counts, aes(x=year, y=n)) +
    geom_line(aes(color=species_id, linetype=sex)) +
    facet_grid( ~ species_id)              

# split vertically
ggplot(d_counts, aes(x=year, y=n)) +
    geom_line(aes(color=species_id, linetype=sex)) +
    facet_grid(species_id ~ .)              

# split both ways, using two variables
p <- ggplot(d_counts, aes(x=year, y=n)) +
    geom_line(aes(color=species_id, linetype=sex)) +
    facet_grid(sex ~ species_id) 

ggsave("d_counts_plot.png",p, height=8, width=8)

# themes
p + theme_bw()

