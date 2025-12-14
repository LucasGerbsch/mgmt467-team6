Link to looker dashboard: https://lookerstudio.google.com/reporting/68d2356b-d7e9-4d0a-bd5f-a13b68639183

Historical NYC CitiBike and Forecast Data Trends (Years 2022-2024)\
2022-2024 Daily Trips\
We have two dashboards present in our Looker Studio. The first is a historical dashboard that displays NYC CitiBike trip data and open-meteo forecast data from 1/1/2022-12/31/2024.\
This shows us the trends amongst Citibike Usage through the years and how weather forecasts influence consumer behaviour, allowing us to capitalize on these historical insights. Particularly in this graph, it become visible that for each year, there is a spike in Citibike overall usage in the months that tend to have warmer weather, and a dip in the winter months, from about mid November to mid March. This is consistent with our predictions of when there is more demand for Citibikes. Additionally, while the number of casual trips is always lower than the numbere of member trips, it is also seen that the months with warmer weather see a higher number of casual trips than the months with colder weather. 

2022-2024 Total Daily Trips vs. Forecast Average Temperature (Farenheit)\
This graph shows a clear correlation between the forecast average temperature and the total number of trips taken. A spike in temperature leads to a dpike in the total trips, and vice versa, where a dip in temperatures tends to lead to a lower number of Citibike trips. It also indicates that regardless of the weather, there are about 20,000 or more trips being taken even in the coldest of weather, which may indicate that there is a subset of people that rely on Citibikes as a source of transportation regardless of the temperatures. 

2022-2024 Total Trips by Day of the Week\
This graph is a bar graph indicating the average number of total trips taken over the years of 2022-2024 for each day of the week. Across the board, the day with the least trips taken on average is Sunday, at 13011005 trips, then followed by Monday with 14897541 trips, with Saturday at a slight increase in number of rides, coming in at 14955335 trips. The most number of trips taken are during the weekdays, with Wednesdays having the highest trips, followed by Thursday, Friday, then Tuesdays right in the middle of the rankings. 

We then have our Real-Time Streaming Dashboard, which has Predicted CitiBike Trip Data over the Next 7 Days.\
As of 2025-12-13, 9:16 PM UTC the dashboard is displaying the following predicted metrics based on the 7 day forecast provided by the open-meteo API:\
Total Predicted Casual Trips: 57744\
Total Predicted Member Trips: 412279\
Predicted Total Trips: 470023

We can also see:
- the distribution of Predicted Casual Trips over the Next 7 Days as a time-series bar chart indicating the number of predicted casual trips for each day
- the distribution of Predicted Member Trips over the Next 7 Days as a time-series bar chart indicating the number of predicted member trips for each day
- the predicted Total Trips vs. Forecast Average Temperature in Farenheit for the next 7 days
- the predicted Total Trips vs. Forecase Max Wind Speed (MPH) for for the next 7 days
