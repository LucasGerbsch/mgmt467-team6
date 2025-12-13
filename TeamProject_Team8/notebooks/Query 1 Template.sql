CREATE OR REPLACE EXTERNAL TABLE `ProjectIDPlaceholder.bike_raw.citibike_trips_ext` (
  ride_id STRING,
  rideable_type STRING,
  started_at TIMESTAMP,
  ended_at TIMESTAMP,
  start_station_name STRING,
  start_station_id STRING,
  end_station_name STRING,
  end_station_id STRING,
  start_lat FLOAT64,
  start_lng FLOAT64,
  end_lat FLOAT64,
  end_lng FLOAT64,
  member_casual STRING
)
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://ProjectIDPlaceholder/citibike/raw/year=2022/*',
    'gs://ProjectIDPlaceholder/citibike/raw/year=2023/*',
    'gs://ProjectIDPlaceholder/citibike/raw/year=2024/*'
  ],
  skip_leading_rows = 1
);


CREATE OR REPLACE TABLE `ProjectIDPlaceholder.bike_curated.bike_daily`
PARTITION BY date AS
SELECT
  DATE(started_at, "America/New_York") AS date,
  COUNT(*) AS trips,
  COUNTIF(member_casual = 'member') AS member_trips,
  COUNTIF(member_casual = 'casual') AS casual_trips
FROM `ProjectIDPlaceholder.bike_raw.citibike_trips_ext`
WHERE started_at >= TIMESTAMP('2022-01-01 00:00:00', "America/New_York")
  AND started_at <  TIMESTAMP('2025-01-01 00:00:00', "America/New_York")
GROUP BY date;


SELECT MIN(date) min_date, MAX(date) max_date, COUNT(*) days
FROM `ProjectIDPlaceholder.bike_curated.bike_daily`;