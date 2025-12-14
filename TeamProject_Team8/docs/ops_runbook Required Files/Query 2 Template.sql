# Raw Table Creation
CREATE OR REPLACE EXTERNAL TABLE `ProjectIDPlaceholder.bike_raw.weather_daily_ext` (
  date DATE,
  temperature_2m_max FLOAT64,
  temperature_2m_min FLOAT64,
  precipitation_sum FLOAT64,
  wind_speed_10m_max FLOAT64,
  timezone STRING,
  temperature_unit STRING,
  wind_speed_unit STRING,
  precipitation_unit STRING,
  unit_temperature_2m_max STRING,
  unit_temperature_2m_min STRING,
  unit_precipitation_sum STRING,
  unit_wind_speed_10m_max STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://BucketIDPlaceholder/weather/raw/open_meteo_daily_monthly/*_us_units.csv'],
  skip_leading_rows = 1
);

# Row Check
SELECT * FROM `ProjectIDPlaceholder.bike_raw.weather_daily_ext` LIMIT 10;
SELECT MIN(date) AS min_date, MAX(date) AS max_date, COUNT(*) AS row_count
FROM `ProjectIDPlaceholder.bike_raw.weather_daily_ext`;

# Curated Table Creation
CREATE OR REPLACE TABLE `ProjectIDPlaceholder.bike_curated.weather_daily`
PARTITION BY date AS
SELECT
  date,
  temperature_2m_max,
  temperature_2m_min,
  precipitation_sum,
  wind_speed_10m_max
FROM `ProjectIDPlaceholder.bike_raw.weather_daily_ext`;

# Weather Data Sanity Check
SELECT
  MIN(temperature_2m_min) AS min_tmin_f,
  MAX(temperature_2m_max) AS max_tmax_f,
  MIN(wind_speed_10m_max) AS min_wind_mph,
  MAX(wind_speed_10m_max) AS max_wind_mph,
  MIN(precipitation_sum) AS min_precip_in,
  MAX(precipitation_sum) AS max_precip_in
FROM `ProjectIDPlaceholder.bike_curated.weather_daily`;

SELECT date, temperature_2m_min
FROM `ProjectIDPlaceholder.bike_curated.weather_daily`
ORDER BY temperature_2m_min ASC
LIMIT 10;

SELECT
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  AVG(temperature_2m_min) AS avg_tmin_f
FROM `ProjectIDPlaceholder.bike_curated.weather_daily`
GROUP BY year, month

ORDER BY year, month;
