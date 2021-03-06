
library(tidyverse)
library(readxl) 
library(haven)
library(ggplot2)
source(here::here(""))

both_years = read_dta("Documents/LTC COVID/deaths_19_20_gender_location_age.dta")

both_years = both_years %>% 
  mutate(YEAR = if_else(year >= 20, "2020", "2019"))

# Creating a tibble of the total deaths across all locations 
summary_week= 
  both_years %>% 
  group_by(year,week,Sex,Ageband) %>% 
  summarise(total_deaths= sum(Deaths))

summary_week= summary_week %>% 
  mutate(Year = if_else(year >= 20, "2020", "2019"))


sex.labs <- c("Females", "Males")
names(sex.labs) <- c("F", "M")
# Deaths in all locations 2020 v 2019, weeks 12-20
summary_week %>% 
  filter(week > 11) %>% 
  filter(Ageband != "0") %>% 
  filter(Ageband != "1-14") %>% 
  filter(Ageband != "15-44") %>%
  ggplot(aes(x      = week,
             y      = total_deaths,
             fill   = Year)) +
  scale_fill_brewer(palette="Paired") +
  scale_x_continuous(breaks = c(12,13,14,15,16,17,18,19,20)) +
  geom_col(position = "dodge") +
  labs(x = "Week Number",
       y = "Number of deaths (all locations)") +
  theme_minimal() +
  facet_wrap(~Ageband ~Sex, ncol=2 , scales="free_x", labeller = labeller(Sex=sex.labs))
ggsave("deaths_sex_age_19_vs_20.png")
