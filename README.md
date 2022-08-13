---
title: "Google Data Analytics Capstone project"
subtitle: "Cyclistic Case Study"
---

### Introdution

For the capstone project of the Google Data Analytics certificate, I have chosen the Cyclistic bike share data to work on. For the case study, I will perform real-world tasks of a junior data analyst for the marketing team at Cyclistic, a fictional bike-share company in Chicago.
To answer key business questions, I will follow the six steps of the data analysis process : Ask, Prepare, Process, Analyze, Share and Act.


### The scenario

The director of marketing of Cyclistic, Lily Moreno, believes that the company’s future growth depends on maximizing the number of annual memberships. Hence, the marketing analyst team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, the analytics team could be able to design a new marketing strategy to convert casual riders into annual members. 

Three questions will guide the future marketing campaign:

1.How do annual members and casual riders use Cyclistic bikes differently?

2.Why would casual riders buy Cyclistic annual memberships?

3.How can Cyclistic use digital media to influence casual riders to become members?

I have been assigned by Moreno the first question. 


### The Ask phase

* A statement of the business task: 

Cyclistic has concluded that annual members are much more profitable than casual riders. So, we want to design a marketing strategies and a campaign that helps us converting casual riders into annual members. 

* My key stakeholders are: 

1-Lily Moreno: The director of marketing and my manager. Moreno has initiated   this  strategy. The first stakeholder to deliver to. 

2-The executive team: For Moreno´s idea to work, the executive team must approve our recommendations, so so they must be backed up with compelling data insights and professional data visualizations.


### The Prepare phase

Data Source: 
Past 12 month of original bike share data set from 01/06/2021 to 31/05/2022 was extracted as 12 zipped .csv 
Data Organization & Description:

File naming convention: YYYY_MM

File Type:  csv  format 

File Content: Each csv file consist of 13 columns which contain information related to ride id, rider type, ride start and end time, start and end location  etc. Number of rows varies between 49k to 531k from different excel files.


Data credibility: The dataset follows the ROCCC Analysis as described below:

The data set is reliable, the data is complete and accurate for the chosen time window.
The data is original, it is a first arty information.
The data is comprehensive, the data set contains all information needed to answer the question.
The data is current, rider data of the last 12 months was used.
The data is cited and vetted by Chicago department of transportation.

Data Security: Riders’ personal identifiable information is hidden through tokenization.

Original files are backed up in a separate folder.

Data Limitations: As riders’ personal identifiable information is hidden, thus will not be able to connect pass purchases to credit cards numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.


### The Process Phase

I used R for data verification and cleaning: Reasons:
The 12 data sets combined will contain more than 5 million rows of data. Excel worksheet limitation is 1,048,576 rows. Moreover, some csv files could not uploaded to BigQuery for file size problems. Thus, R is used to perform all tasks from organizing, cleaning analyzing and visualizing data.

Steps

1. Load all of the libraries I used: tidyverse, lubridate, hms, data.table

2. Uploaded all of the original data from the data source divytrip into R using read_csv function to upload all individual csv files and save them in separate data frames. For august 2020 data I saved it into aug08_df, september 2020 to sep09_df and so on.

3. Merged the 12 months of data together using rbind to create a one year view

4. Created a new data frame called cyclistic_date that would contain all of my new columns


### The Analyse Phase

Key tasks
- Aggregate your data so it’s useful and accessible.

- Organize and format your data.
1. Created new columns for:

Start Time :- split start_time to date and time
Ride Length :- did this by subtracting end_at time from start_at time
Month
Day
Year
Day of the Week
Season :- Spring, Summer, Winter or Fall
Hour
Time of Day :- Night, Morning, Afternoon or Evening

2. Cleaned the data by:

- Remove unnecessary columns :- ride_id, start_station_id, end_station_id, start_lat, start_long, end_lat, end_lng
- Remove where ride_length is 0 or negative (ride_length should be a positive number)
- Remove rows with NA values (blank rows)
- Removing duplicate rows

- Perform calculations.
1. Calculated Total Rides and Average Ride Length for:

Total number of rides which was just the row count
Member type - casual riders vs. annual members
Type of Bike - classic vs docked vs electric; separated by member type; total rides and average ride length for each bike type
Hour - separated by member type; total rides and average ride length for each hour in a day
Time of Day - separated by member type; total rides and average ride length for each time of day (morning, afternoon, evening, night)
Day of the Week - separated by member type; total rides and average ride length for each day of the week
Day of the Month - separated by member type; total rides and average ride length for each day of the month
Month - separated by member type; total rides and average ride length for each month
Season - separated by member type; total rides and average ride length for each season (spring, summer, fall, winter)

- Identify trends and relationships.
	

### The Share phase 

Using the visulization created in R 
- from the analysis these are my findings 
	1- Number of rides for casual users is increased around the weekends.
	2- The duration of rides is consistant for member users throughout the week.
	3- Casual riders use the bikes for longer rides compared to member users.

#### Conclusions/Summary of insights 

Members and casual riders differ in how long they use the bikes, how often they use the bikes, and on which days of the week does every group peak:

* Casual rides peak during weekends. There is a high probability they are tourists visiting and sightseeing the city, or that they are ordinary Chicago residents who are riding bike in their leisure time during the weekend. The longer average ride time for casual rider, also peaking at the weekend,  provides evidence for this point.

* Ride length for members are relatively shorter compared to casual riders. This could clarified as such, that most members use the bikes to commute on workdays. This clarification would also explain the short riding durations of members. They ride from point A to B, namely roughly always the same ride lengths and the same distance

* More than 50% of the riders are annual members, suggesting that the company have already achieved a certain level of loyalty among its bike users. This indicates a positive message, namely that the company is going to be able to convince many casual riders to convert to members, and to keep the new members satisfied. 


### The Act Phase

Based on my analysis these are my recommendations 
	* Better deals for casual members around the weekend to get them to sign up for a membership 
	* Introduce more options for people with disabilities
  * Give discounts for longer rides when you have a membership
  * Longer rides can get some type of rewards program when they become members
  * The marketing campaign should be launched between February to August, as the number of trips made by casual riders peaks at this time of the year.
  * The campaign could include ride-length-based tariff plan (maybe only on weekends): Bike more, pay less ! 
    This provides more incentive for the member rides to cycle longer distances. 
  * Alternatively, longer rides can be rewarded with benefits such as discount vouchers. 
