CREATE OR REPLACE TABLE `ProjectIDPlaceholder.bike_curated.bike_weather_daily`
PARTITION BY date AS
SELECT
  b.date,
  b.trips,
  b.member_trips,
  b.casual_trips,
  w.temperature_2m_max,
  w.temperature_2m_min,
  w.precipitation_sum,
  w.wind_speed_10m_max
FROM `ProjectIDPlaceholder.bike_curated.bike_daily` b
JOIN `ProjectIDPlaceholder.bike_curated.weather_daily` w
USING (date);

SELECT * 
FROM `ProjectIDPlaceholder.bike_curated.bike_weather_daily`
ORDER BY date DESC
LIMIT 20;

SELECT
  (SELECT COUNT(*) FROM `ProjectIDPlaceholder.bike_curated.bike_daily`) AS bike_days,
  (SELECT COUNT(*) FROM `ProjectIDPlaceholder.bike_curated.weather_daily`) AS weather_days,
  (SELECT COUNT(*) FROM `ProjectIDPlaceholder.bike_curated.bike_weather_daily`) AS joined_days;

SELECT
  MIN(date)  AS min_date,
  MAX(date)  AS max_date,
  COUNT(*)   AS day_count
FROM `ProjectIDPlaceholder.bike_curated.bike_weather_daily`;
