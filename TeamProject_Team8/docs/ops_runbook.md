Runops Full Project Setup Instructions

STARTING NOTE: Please make sure to name your bucket folders, your databases, and tables the exact same way I do so they are identical and will work with our queries and Colab Notebook.

Before we begin, please download the Runops Template Notebook and all 5 Queries from the Runops Files Subdirectory in GitHub.

Create a new project in GCP

Ensure the following APIs are enabled by going to APIs and Services -> Library:

BigQuery API

BigQuery Storage API

Cloud Storage API

Cloud Pub/Sub API

Dataflow API

Cloud Run Admin API

Cloud Scheduler API

Cloud Build API

Artifact Registry API

Cloud Logging API/ Cloud Monitoring API (Usually already enabled)

Manually create 2 new Databases in BigQuery: One named “bike_raw” and one named “bike_curated.” Bike_raw will store our raw CitiBike, historical weather, and steaming forecast data while bike_curated will be used to store our curated tables.

Go to Cloud Storage -> Buckets and create a bucket called “mgmt467-final-project”

Create 2 folders within the bucket: One named “citibike” and one named “weather.” Within the Citibike folder, create a subfolder named “raw.” Inside of the “raw” folder, create a unique year subfolder for each year of CitiBike data you plan to download. The format should be “year=insert whatever year here i.e. 2022” so for example “year=2022,” “year=2023,” etc.

Inside of each year folder, create subfolders for each month. The format should be “month=01,” “month=02,” etc. Repeat until you have folders for months 1 through 12 in each year folder.

Visit https://s3.amazonaws.com/tripdata/index.html
 which is NYC CitiBike’s website bucket that contains ZIP files for the years 2013-2025 currently. They have already prepared full year ZIP files for 2013-2023, but have all the individual files that you can download for 2024 and 2025 to manually make your own full year collections. This runops is specifically for using the years 2022, 2023, and 2024 but feel free to adapt it to add more years as desired (WARNING: The way they format the CSVs and the data within them changes multiple times between their 2013 and 2021 files so be aware that there will be more data normalization and standardization efforts required if you choose to include those files).

Unzip all of the year files and the month zip files within them to get access to all of the CSVs

Go back to your bucket and manually upload each set of monthly CSV files into their respective year’s monthly folders. Example: Upload all of the 202210 CSV files into “month=10” folder in your “year=2022” folder. Repeat for all years and months.

Once you have done this, it’s time to pull historical forecast data from the API. Please download the “Runops Template Notebook” from the GitHub Repository and open it in Colab. Follow along with the instructions.

Run the first cell to authenticate, then run the second cell to pull the historical forecast data. Remember to change START_DATE and END_DATE to match the year range you decided on when downloading the CSVs off of the CitiBike webpage. Remember that since the formatting is different for earlier years’ CSVs, you will have to deal with the standardization and normalization on your own if you did not select 2022-2024 or later.

Next we push the historical forecast data from the API to our weather folder in our bucket. Replace “ProjectIDPlaceholder” with your project ID and run the cell.

Run the sanity check at the bottom to ensure that your coordinates match with NYC

Go back to your bucket and select folders weather -> raw -> open_meteo_daily_monthly. When selecting this final folder, you should see csv files for each year-month pair in U.S. units.

From this point forward, I will only be giving instructions on how to build the project for the 2022-2024 range as we did since the actions will vary when using other date ranges. Please utilize Gemini, ChatGPT, another AI, or your own technical knowledge to adapt the source materials to fit your own variant of the date range if you choose.

Upload the 5 queries from the Runops Files Subdirectory in GitHub to BigQuery by clicking the 3 dots next to the Queries dropdown in BigQuery and then selecting “Upload SQL Query” and using the Browse file upload option.

Run Query Template 1 to create our full raw CitiBikes data table and the curated table. Don’t forget to change the placeholder project ID to your project ID. We have a quality check at the bottom to ensure that our min and max date are within our selected range (2022-2024).

Run Query Template 2 after changing the placeholder project ID to yours to create our full raw historical forecast table and curated table. We have some sanity checks at the bottom to ensure our values are reasonable.

Run Query Template 3 after changing the placeholder project ID to yours to join our CitiBike and forecast curated tables into one. Our training table for our ML model is now complete.

Run Query Template 4 after changing the placeholder project ID to yours, this will prepare a new table for streaming.

Next, we return to the notebook and run all of the cells under the ML model section. Remember to change the project ID to yours. Once you’ve run all of the ML model cells, your model is now trained. Use ML.EVALUATE to evaluate the model performance.

Now we begin the streaming pipeline creation. In GCP, go to Pub/Sub -> Topics and click “Create topic.” Name the topic “citibike-weather-topic” with default settings and create. You should have a topic called “citibike-weather-topic” and a subscription called “citibike-weather-sub.” Click on the subscription and hit edit. Select the delivery type as pull, set message retention to 7 days, and set acknowledgement deadline to 10 seconds.

Navigate to Cloud Run in GCP and select “Create Job.” Name it “open-meteo,” change the region to your desired region and select “Create Job.” Go into the now created “open-meteo” and select “Edit & deploy new revision.” Under containers, look at “Edit Container” and select the “Variables and Secrets” tab. Add a variable called “TOPIC_ID” with the value “citibike-weather-topic.” Click the deploy button at the bottom. When you click on the URL at the upper middle of the page, it should open a new tab that says “Published 7 forecast messages at (time)” if you’ve done everything correctly.

Navigate to Dataflow -> Jobs -> Create Job in GCP. Name the job “citibike-weather-stream” with your desired region and select “Pub/Sub Subscription to BigQuery” as your dataflow template. Under “Required Parameters,” select “bike_raw.weather_forecast_stream” as your output table, “subscriptions/citibike-weather-sub” as your input subscription, and select “Exactly Once” for your streaming mode. Use “yourProjectIDHere/dataflow-temp” as your temp location and finally hit “Run job.”

Search for “Cloud Scheduler” in GCP and create a job. Make the job name “open-meteo-every-minute” with your preferred region and use “*****” as your frequency. This will make the scheduler call the API every minute. Change your Time Zone to America/New_York. Make the target the same URL that you clicked in your Cloud Run and choose the method as “Get.” Set authentication as None because Cloud Run is set to allow unauthenticated. Your pipeline is now complete.

While your Dataflow and Cloud Scheduler jobs are running, you should see new 7 day forecast data being ingested into your raw streaming table every minute.

Run Query 5 Template after changing the placeholder project ID to yours to create our curated streaming table, put it into our ML model, and finally create the final table with the predicted trip daily trip values with the respective forecast data. This table is called “trips_forecast” and you can use it in Looker Studio to make a real-time analytics dashboard.

Return to the Colab notebook and go to the Pub/Sub Prediction Testing section. Run the cells to make sure that the tables look logical and use ML.EXPLAIN_PREDICT to investigate some of our predictions from our live streaming data.

To stop the pipeline, select the job in Dataflow and hit the stop button at the top and select “Drain.” Next, go to Cloud Scheduler and select the checkbox next to the job and hit pause.

To restart the pipeline, select the ended job in Dataflow, select the clone option, select the run job option at the bottom without changing anything, and a new identical job will begin. Next, go to Cloud Scheduler and select the checkbox next to the job and hit resume.

Rerun Query 5 any time you want to update the predictions table and dashboard data. Make sure to select “Refresh data” in Looker Studio to update the visualized dashboard data. 
