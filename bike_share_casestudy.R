# Environment set up using get() and set()


## Step2 - Prepare Phase

# Install packages

install.packages("tidyverse")
install.packages("skimr")
install.packages("janitor")
install.packages("lubridate")
install.packages("data.table")

# Load libraries

library(tidyverse)
library(readr)
library(dplyr)
library(ggplot2)
library(skimr)
library(janitor)
library(lubridate)
library(data.table)

# Import data files

jun_21 <- read_csv("202105-divvy-tripdata.csv")
jul_21 <- read_csv("202106-divvy-tripdata.csv")
aug_21 <- read_csv("202107-divvy-tripdata.csv")
sep_21 <- read_csv("202108-divvy-tripdata.csv")
oct_21 <- read_csv("202109-divvy-tripdata.csv")
nov_21 <- read_csv("202110-divvy-tripdata.csv")
dec_21 <- read_csv("202111-divvy-tripdata.csv")
jan_22 <- read_csv("202112-divvy-tripdata.csv")
feb_22 <- read_csv("202201-divvy-tripdata.csv")
mar_22 <- read_csv("202202-divvy-tripdata.csv")
apr_22 <- read_csv("202203-divvy-tripdata.csv")
may_22 <- read_csv("202204-divvy-tripdata.csv")

# lists all column names

colnames(jun_21)
colnames(jul_21)
colnames(aug_21)
colnames(sep_21)
colnames(oct_21)
colnames(nov_21)
colnames(dec_21)
colnames(jan_22)
colnames(feb_22)
colnames(mar_22)
colnames(apr_22)
colnames(may_22)

# View data

glimpse(jun_21)
glimpse(jul_21)
glimpse(aug_21)
glimpse(sep_21)
glimpse(oct_21)
glimpse(nov_21)
glimpse(dec_21)
glimpse(jan_22)
glimpse(feb_22)
glimpse(mar_22)
glimpse(apr_22)
glimpse(may_22)

# Lists all column names and data types(numeric, character, double etc)

str(jun_21)
str(jul_21)
str(aug_21)
str(sep_21)
str(oct_21)
str(nov_21)
str(dec_21)
str(jan_22)
str(feb_22)
str(mar_22)
str(apr_22)
str(may_22)

# Compare column names each of the files to make sure everything will harmonize 

compare_df_cols(jun_21, jul_21, aug_21, sep_21, oct_21, nov_21,
                dec_21, jan_22, feb_22, mar_22, apr_22, may_22,
                return = "mismatch")

# Combine all data files into one data frame

full_year <- bind_rows(jun_21, jul_21, aug_21, sep_21, oct_21, nov_21,
                       dec_21, jan_22, feb_22, mar_22, apr_22, may_22)

# Inspecting data frame

nrow(full_year)
ncol(full_year)
dim(full_year) # 5757551      13
colnames(full_year)
head(full_year)
tail(full_year)
str(full_year)
glimpse(full_year)
summary(full_year)

# Creating duplicate data frame

yearly_bike_data <- full_year 
glimpse(yearly_bike_data)



## Step3 - Process Phase

# Get summary of data, check missing data

skim(yearly_bike_data)

# Removing unused column.

yearly_bike_data <- yearly_bike_data %>%
  select(-c(start_lat, start_lng, end_lat, end_lng))

# Inspecting data frame for inconsistencies

colnames(yearly_bike_data)
dim(yearly_bike_data) # 5757551       9
glimpse(yearly_bike_data)
str(yearly_bike_data)
summary(yearly_bike_data)

# Renaming columns

yearly_bike_data <- yearly_bike_data %>%
  rename(trip_id = ride_id, ride_type = rideable_type,
         start_time = started_at, end_time = ended_at,
         from_station_name = start_station_name,to_station_name = end_station_name,
         from_station_id = start_station_id, to_station_id = end_station_id,
         user_type = member_casual)

# Inspecting data frame for inconsistencies

colnames(yearly_bike_data)
head(yearly_bike_data)
str(yearly_bike_data)
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Remove empty rows and columns

yearly_bike_data <- yearly_bike_data %>%
  remove_empty(which = c('cols', 'rows')) %>%
  clean_names()

# Inspecting data frame for inconsistencies

dim(yearly_bike_data) # 5757551       9
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Checking and Removing null values in data

sum(is.na(yearly_bike_data)) # 14461138
yearly_bike_data <- drop_na(yearly_bike_data)

# Inspecting data frame for inconsistencies

dim(yearly_bike_data) # 137889       9
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Checking for entries with NA and keep only completed rows

sum(!complete.cases(yearly_bike_data))
yearly_bike_data <- yearly_bike_data[complete.cases(yearly_bike_data),]

# Inspecting data frame for inconsistencies

dim(yearly_bike_data) # 137889       9
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Removing duplicates in data

full_year1 <- yearly_bike_data[!duplicated(yearly_bike_data$trip_id),] 
print(paste("Removed", nrow(yearly_bike_data)-nrow(full_year1), "duplicated rows"))
yearly_bike_data <- full_year1

# Inspecting data frame for inconsistencies

dim(yearly_bike_data) # 137889       9
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Change start_time and end_time into time and date

yearly_bike_data$start_time <- as.factor(yearly_bike_data$start_time)
yearly_bike_data$start_time <- as.POSIXct(yearly_bike_data$start_time, 
                                          format = "%m/%d/%Y %H:%M:%S")
yearly_bike_data$end_time <- as.factor(yearly_bike_data$end_time)
yearly_bike_data$end_time <- as.POSIXct(yearly_bike_data$end_time,
                                        format = "%m/%d/%Y %H:%M:%S")

# Inspecting data frame for inconsistencies

glimpse(yearly_bike_data)
summary(yearly_bike_data)
str(yearly_bike_data)

# Filtering out start_time less than end_time

yearly_bike_data <- yearly_bike_data %>%
  filter(yearly_bike_data$start_time < yearly_bike_data$end_time)

# Inspecting data frame for inconsistencies

dim(yearly_bike_data) # 136868       9
head(yearly_bike_data)
glimpse(yearly_bike_data)

# New summary

skimr::skim_without_charts(yearly_bike_data)

# Inspecting data frame for inconsistencies

nrow(yearly_bike_data)
ncol(yearly_bike_data)
dim(yearly_bike_data) # 136868       9
colnames(yearly_bike_data)
head(yearly_bike_data)
tail(yearly_bike_data)
str(yearly_bike_data)
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Creating columns to calculate ride duration per ride

yearly_bike_data$ride_length <- 
  difftime(yearly_bike_data$end_time, yearly_bike_data$start_time)

# Checking and converting ride_length to numeric 

is.numeric(yearly_bike_data$ride_length)
yearly_bike_data$ride_length <- 
  as.numeric(as.character(yearly_bike_data$ride_length))

# Inspecting data frame for inconsistencies

dim(yearly_bike_data) # 136868      12
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Checking for negative ride_length

all(yearly_bike_data$ride_length <= 0)
any(yearly_bike_data$ride_length <= 0)
sum(yearly_bike_data$ride_length <= 0)

nrow(yearly_bike_data)

# Removing negative ride_length

yearly_bike_data <- yearly_bike_data[!( yearly_bike_data$ride_length <= 0),]
dim(yearly_bike_data) # 136868      12
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Split start_time into date and time

yearly_bike_data <- yearly_bike_data %>%
  separate(start_time,
           into = c("date", "time"),
           sep = " ",
           remove = FALSE)

# Inspecting data frame for inconsistencies

dim(yearly_bike_data) # 136868       11
head(yearly_bike_data)
glimpse(yearly_bike_data)

# Adding columns for month, day, year, day_of_week into data frame

yearly_bike_data$month <- format(as.Date(yearly_bike_data$date), "%m")
yearly_bike_data$day <- format(as.Date(yearly_bike_data$date), "%d")
yearly_bike_data$year <- format(as.Date(yearly_bike_data$date), "%Y")
yearly_bike_data$day_of_week <- format(as.Date(yearly_bike_data$date), "%u")

# Changing attribute name of month and day_of_week for data consistency

table(yearly_bike_data$month)
yearly_bike_data <- yearly_bike_data %>%
  mutate(month = recode(month,
                        "01" = "Jan", "02" = "Feb", "03" = "Mar", "04" = "Apr", 
                        "05" = "May", "06" = "Jun", "07" = "Jul", "08" = "Aug", 
                        "09" = "Sep", "10" = "Oct", "11" = "Nov", "12" = "Dec"))
yearly_bike_data %>% 
  distinct(month)

table(yearly_bike_data$day_of_week)
yearly_bike_data <- yearly_bike_data %>%
  mutate(day_of_week = recode(day_of_week,
                              "1" = "Mon", "2" = "Tues","3" = "Wed", 
                              "4" = "Thurs", "5" = "Fri","6" = "sat", 
                              "7" = "Sun",))
yearly_bike_data %>%
  distinct(day_of_week)

# Creating season column

yearly_bike_data$season <- 
  ifelse(yearly_bike_data$month %in% c('Jun', 'Jul', 'Aug'), "Summer",
         ifelse(yearly_bike_data$month %in% c('Sep', 'Oct', 'Nov'), "Fall",
                ifelse(yearly_bike_data$month %in% c('Dec', 'Jan', 'Feb'), "Winter",
                       ifelse(yearly_bike_data$month %in% c('Mar', 'Apr', 'May'), "Spring",
                              NA))))

# Inspecting data frame for inconsistencies

dim(yearly_bike_data) # 136868      18
colnames(yearly_bike_data)
str(yearly_bike_data)
glimpse(yearly_bike_data)
summary(yearly_bike_data)

# Extract only hours from time for data visualization purpose

yearly_bike_data$hour <- substr(yearly_bike_data$time, 1, 2)

#create column for different time_of_day: Night, Morning, Afternoon, Evening

yearly_bike_data <- yearly_bike_data %>% 
  mutate(time_of_day = 
           case_when(hour == "00" ~ "Night", hour == "01" ~ "Night",
                     hour == "02" ~ "Night", hour == "03" ~ "Night",
                     hour == "04" ~ "Night", hour == "05" ~ "Night",
                     hour == "06" ~ "Morning", hour == "07" ~ "Morning",
                     hour == "08" ~ "Morning", hour == "09" ~ "Morning",                                 
                     hour == "10" ~ "Morning", hour == "11" ~ "Morning",                                  
                     hour == "12" ~ "Afternoon", hour == "13" ~ "Afternoon",                                  
                     hour == "14" ~ "Afternoon", hour == "15" ~ "Afternoon",                                 
                     hour == "16" ~ "Afternoon", hour == "17" ~ "Afternoon",                                 
                     hour == "18" ~ "Evening", hour == "19" ~ "Evening",                                
                     hour == "20" ~ "Evening", hour == "21" ~ "Evening",                                 
                     hour == "22" ~ "Evening",  hour == "23" ~ "Evening") 
  )
                                                       
# Inspecting data frame for inconsistencies

colnames(yearly_bike_data)
dim(yearly_bike_data) # 136868     19
glimpse(yearly_bike_data)

# Checking for test station

nrow(subset(yearly_bike_data, from_station_name %like% "TEST"))
nrow(subset(yearly_bike_data, from_station_name %like% "Test"))
nrow(subset(yearly_bike_data, from_station_name %like% "test"))

# New summaries

skim(yearly_bike_data)



## Step4 - Analyse Phase

# Summary statistics for ride_length

summary(yearly_bike_data$ride_length)

# Descriptive analysis

mean(yearly_bike_data$ride_length) # straight average
median(yearly_bike_data$ride_length) # midpoint in array of ride_length
max(yearly_bike_data$ride_length) # longest ride
min(yearly_bike_data$ride_length) # shortest ride

# Compare user_type

aggregate(yearly_bike_data$ride_length ~ yearly_bike_data$user_type, FUN = mean)
aggregate(yearly_bike_data$ride_length ~ yearly_bike_data$user_type, FUN = median)
aggregate(yearly_bike_data$ride_length ~ yearly_bike_data$user_type, FUN = max)
aggregate(yearly_bike_data$ride_length ~ yearly_bike_data$user_type, FUN = min)

# summary of yearly_bike_data by user_type

yearly_bike_data %>%
  group_by(user_type) %>%
  summarise(average_ride_length = mean(ride_length),
            median_length = median(ride_length),
            max_ride_length = max(ride_length),
            min_ride_length = min(ride_length),
            total_trips = n()) %>%
  arrange(-total_trips)

# User trends

yearly_bike_data %>% 
  group_by(user_type) %>%
  summarise(ride_count = length(ride_length))

# Average duration by user_type

yearly_bike_data %>%
  group_by(user_type) %>%
  summarise(number_of_rides = n(),
            average_ride_length = mean(ride_length), .groups = "drop")

# Average duration by user_type and day_of_week

yearly_bike_data %>%
  group_by(user_type, day_of_week) %>%
  summarise(number_of_rides = n(),
            average_ride_length = mean(ride_length), .groups = "drop") %>%
  arrange(user_type, day_of_week)

# Analysis in percentage

yearly_bike_data %>% 
  group_by(user_type) %>%
  summarise(count = length(trip_id),
            'Percentage' = (length(trip_id)/nrow(yearly_bike_data))*100)
yearly_bike_data %>%
  group_by(day_of_week) %>%
  summarise(count = length(trip_id),
            'Percentage' = (length(trip_id)/nrow(yearly_bike_data))*100,
            'casual_p' = (sum(user_type == 'casual')/length(trip_id))*100,
            'member_p' = (sum(user_type == 'casual')/length(trip_id))*100,
            '% Difference' = member_p - casual_p)
yearly_bike_data %>%
  group_by(month) %>%
  summarise(count = length(trip_id),
            'Percentage' = (length(trip_id)/nrow(yearly_bike_data))*100,
            'casual_p' = (sum(user_type == 'casual')/length(trip_id))*100,
            'member_p' = (sum(user_type == 'casual')/length(trip_id))*100,
            '% Difference' = member_p - casual_p)

# View the final data

View(yearly_bike_data)

#-----------------------------------------TOTAL RIDES--------------------------------------

# Total number of rides

nrow(yearly_bike_data)

#-----------------MEMBER TYPE---------------------

yearly_bike_data %>%
  group_by(user_type) %>% 
  count(user_type)

#----------------TYPE OF BIKE---------------------

# Total rides by member type 

yearly_bike_data %>%
  group_by(user_type, ride_type) %>% 
  count(ride_type)

# Total rides 

yearly_bike_data %>%
  group_by(ride_type) %>% 
  count(ride_type)

#-------------------HOUR--------------------------

# Total rides by member type 

yearly_bike_data %>%
  group_by(user_type) %>% 
  count(hour) %>% 
  print(n = 48) #lets you view the entire tibble

# Total rides

yearly_bike_data %>%
  count(hour) %>% 
  print(n = 24) #lets you view the entire tibble

#----------------DAY OF THE WEEK------------------

# Total rides by member type

yearly_bike_data %>%
  group_by(user_type) %>% 
  count(day_of_week)

# Total rides 

yearly_bike_data %>%
  count(day_of_week)

#----------------------TIME OF DAY-----------------------

#-----morning-------
# Total rides by member type 

yearly_bike_data %>%
  group_by(user_type) %>% 
  filter(time_of_day == "Morning") %>% 
  count(time_of_day)

# Total rides

yearly_bike_data %>%
  filter(time_of_day == "Morning") %>% 
  count(time_of_day)

#-----afternoon-------
# Total rides by member type 

yearly_bike_data %>%
  group_by(user_type) %>% 
  filter(time_of_day == "Afternoon") %>% 
  count(time_of_day)

# Total rides 

yearly_bike_data %>%
  filter(time_of_day == "Afternoon") %>% 
  count(time_of_day)

#-----evening-------
# Total rides by member type

yearly_bike_data %>%
  group_by(user_type) %>% 
  filter(time_of_day == "Evening") %>% 
  count(time_of_day)

# Total rides

yearly_bike_data %>%
  filter(time_of_day == "Evening") %>% 
  count(time_of_day)

#-----night-------
# Number of rides by member type

yearly_bike_data %>%
  group_by(user_type) %>% 
  filter(time_of_day == "Night") %>% 
  count(time_of_day)

# Number of rides 

yearly_bike_data %>%
  filter(time_of_day == "Night") %>% 
  count(time_of_day)

#---all times of day----
# Total rides by member type 

yearly_bike_data %>%
  group_by(user_type) %>% 
  count(time_of_day)

# Number of rides

yearly_bike_data %>%
  group_by(time_of_day) %>% 
  count(time_of_day)

#---------------------MONTH-----------------------

# Total rides by member type 

yearly_bike_data %>%
  group_by(user_type) %>% 
  count(month) %>% 
  print(n = 24) #lets you view the entire tibble

# Total rides
yearly_bike_data %>%
  count(month) 

#----------------DAY OF THE MONTH-----------------

# Total rides by member type

yearly_bike_data %>%
  group_by(user_type) %>% 
  count(day) %>% 
  print(n = 62) #lets you view the entire tibble

# Total rides

yearly_bike_data %>%
  count(day) %>% 
  print(n = 31) #lets you view the entire tibble

#--------------------SEASON-----------------------

#-----spring-------

# Total rides by member type 

yearly_bike_data %>%
  group_by(user_type) %>% 
  filter(season == "Spring") %>% 
  count(season)

# Total rides

yearly_bike_data %>%
  filter(season == "Spring") %>% 
  count(season)

#-----summer-------

# Total rides by member type

yearly_bike_data %>%
  group_by(user_type) %>% 
  filter(season == "Summer") %>% 
  count(season)

# Total rides

yearly_bike_data %>%
  filter(season == "Summer") %>% 
  count(season)

#-----fall-------

# Total rides by member type

yearly_bike_data %>%
  group_by(user_type) %>% 
  filter(season == "Fall") %>% 
  count(season)

# Total rides

yearly_bike_data %>%
  filter(season == "Fall") %>% 
  count(season)

#-----winter-------

# Total rides by member type
yearly_bike_data %>%
  group_by(user_type) %>% 
  filter(season == "Winter") %>% 
  count(season)

# Total rides 
yearly_bike_data %>%
  filter(season == "Winter") %>% 
  count(season)

#-----all seasons-------

# Total rides by member type
yearly_bike_data %>%
  group_by(season, user_type) %>% 
  count(season)

# Total rides
yearly_bike_data %>%
  group_by(season) %>% 
  count(season)




# Step5 - Share Phase

table(yearly_bike_data['user_type'])
table(yearly_bike_data$ride_type)

# User distribution

total_number_of_users <- c(59698, 77166)
pie(total_number_of_users)
pie_labels <- c("casual", "member")
colors <- c("lavender", "purple")
pie(total_number_of_users, label = pie_labels,
    main = "Total Users", col = colors)
legend("bottomright", pie_labels, fill = colors)

# Bike distribution

table(yearly_bike_data['ride_type'])
total_number_of_bikes <- c(97159, 11325, 28380)
pie(total_number_of_bikes)
pie_labels <- c("classic", "docked", "electric")
colors <- c("gray", "orange", 'cyan')
pie(total_number_of_bikes, label = pie_labels,
    main = "Total Bikes", col = colors)
legend("bottomright", pie_labels, fill = colors)

# Insights for number of casual and member

yearly_bike_data %>% 
  group_by(user_type) %>%
  summarise(ride_count = length(ride_length)) %>%
  arrange(user_type) %>%
  ggplot(aes(x = user_type, y = ride_count, fill = user_type)) + 
  geom_col(position = "dodge") +
  ggtitle("Total No. of Rides", subtitle = "June 2021 - May 2022") +
  xlab('User') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# Average distance by user

yearly_bike_data %>%
  group_by(user_type) %>%
  summarise(average_ride_distance = mean(ride_length)) %>%
  ggplot() +
  geom_col(mapping = aes(x = user_type, y = average_ride_distance, fill = user_type),
           show.legend = TRUE) +
  ggtitle('Mean Distance Travelled', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('User') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# Ride type trends

#Count of ride_type by user

yearly_bike_data %>%
  count(ride_type, user_type)

unique(yearly_bike_data$user_type)
unique(yearly_bike_data$ride_type)

# Ride type by user

ggplot(yearly_bike_data, aes(x = ride_type, fill  = user_type)) +
  geom_bar() +
  ggtitle('Ride Type by User',
          subtitle = "Distribution of Bike Types June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Ride Type') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

#  Weekday Trends

# Ridership by weekday and user
ggplot(yearly_bike_data, aes(x = day_of_week, fill  = user_type)) +
  geom_bar(position = "dodge") +
  ggtitle('Daily Ridership by User', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Weekday') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# Average ride duration by user and day_of_week

yearly_bike_data %>%
  group_by(user_type, day_of_week) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>%
  arrange(user_type, day_of_week) %>%
  ggplot(aes(x = day_of_week, y = average_duration, fill  = user_type)) +
  geom_col(position = "dodge") +
  ggtitle('Average Ride Duration by User and Weekday', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Weekday') +
  ylab('Ride Duration') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# Seasonal Trends

yearly_bike_data %>%
  count(season, user_type)

# Season by user

ggplot(yearly_bike_data, aes(x = season, fill  = user_type)) +
  geom_bar(position = "dodge") +
  ggtitle('Seasonal Trends by User', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Season') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# Average ride duration by user_type and season

seasonal_avg_duration <- yearly_bike_data %>%
  group_by(user_type, season) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>%
  arrange(user_type, season)
print(seasonal_avg_duration)

ggplot(seasonal_avg_duration, 
       aes(x = season, y = average_duration, fill = user_type)) +
  geom_col(position = "dodge") +
  ggtitle('Average ride duration by user_type and season', 
          subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Season') +
  ylab('Ride Duration') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# Monthly Trends

monthly_user_count <- yearly_bike_data %>%
  count(month, user_type)
print(monthly_user_count, n = 24)

# Monthly trends by user

ggplot(yearly_bike_data, aes(x = month, fill  = user_type)) +
  geom_bar(position = "dodge") +
  ggtitle('Monthly Trends by User', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Month') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# Average ride duration by user_type and month

monthly_avg_duration <- yearly_bike_data %>%
  group_by(user_type, month) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>%
  arrange(user_type, month)
print(monthly_avg_duration, n = 24)

ggplot(monthly_avg_duration, 
       aes(x = month, y = average_duration, fill = user_type)) +
  geom_col(position = "dodge") +
  ggtitle('Average Ride Duration by User and Month', 
          subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Month') +
  ylab('Ride Duration') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# average trip duration by month and user_type (line graph)

yearly_bike_data %>%
  group_by(user_type, month) %>%
  summarise(average_duration_min = mean(ride_length), .groups = "drop") %>%
  arrange(user_type, month) %>%
  ggplot(aes(x = month, y = average_duration_min, color = user_type)) +
  geom_line(aes(group = user_type)) +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Average Trip Duration by Month and user",
       x = "Month", y = "Average Trip Duration (mins)", color = "user type")

# Hourly trends

# Popular start hours by user

pop_start_hour <- yearly_bike_data %>%
  count(hour, user_type, sort = TRUE)
print(pop_start_hour)

casual_start_hour <-
  filter(pop_start_hour, user_type == 'casual')
casual_start_hour <- casual_start_hour %>%
  arrange(desc(n)) %>%
  slice_head(n = 10)
print(casual_start_hour)

member_start_hour <-
  filter(pop_start_hour, user_type == 'member')
member_start_hour <- member_start_hour %>%
  arrange(desc(n)) %>%
  slice_head(n = 10)
print(member_start_hour)

# Start hour trends by user

ggplot(yearly_bike_data, aes(x = hour, fill  = user_type)) +
  geom_bar(position = "dodge") +
  ggtitle('Start Hour Trends by User', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Start Hour') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#99cad5", "#3f93a2"),
                    labels = c("casual", "member"))

# Popular start hours - casual

ggplot(casual_start_hour, aes(x = hour, y = n)) +
  geom_bar(stat = "identity",
           fill = '#99cad5', colour = "black") +
  ggtitle('Top 10 Start Hours - Casuals', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Start Hour') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) 

# Popular start hours - member

ggplot(member_start_hour, aes(x = hour, y = n)) +
  geom_bar(stat = "identity",
           fill = '#3f93a2', colour = "black") +
  ggtitle('Top 10 Start Hours - Members', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Start Hour') +
  ylab('Ride Count') +
  labs(fill = 'user type') +
  scale_y_continuous(labels = scales::comma) 

# Station trends

# Popular start stations by user

popular_start_station <- yearly_bike_data %>%
  count(from_station_name, user_type)
print(popular_start_station)

# Popular end stations by user

popular_end_station <- yearly_bike_data %>%
  count(to_station_name, user_type)
print(popular_end_station)

# Top 10 start stations - casuals

popular_start_station_casual <-
  filter(popular_start_station, user_type == 'casual')
popular_start_station_casual <- popular_start_station_casual %>%
  arrange(desc(n)) %>%
  slice_head(n = 10)
print(popular_start_station_casual)

ggplot(data = popular_start_station_casual, aes(x = from_station_name, y = n)) +
  geom_bar(stat = "identity",
           fill = '#99cad5', colour = "black") +
  ggtitle('Top 10 Start Stations - Casuals', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Start Station Name') +
  ylab('Ride Count') +
  coord_flip()

# Top 10 start stations - members

popular_start_station_member <-
  filter(popular_start_station, user_type == 'member')
popular_start_station_member <- popular_start_station_member %>%
  arrange(desc(n)) %>%
  slice_head(n = 10)
print(popular_start_station_member)

ggplot(data = popular_start_station_member, aes(x = from_station_name, y = n)) +
  geom_bar(stat = "identity",
           fill = '#3f93a2', colour = "black") +
  ggtitle('Top 10 Start Hours - Members', subtitle = "June 2021 - May 2022") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5)) +
  xlab('Start Station Hour') +
  ylab('Ride Count') +
  coord_flip()

