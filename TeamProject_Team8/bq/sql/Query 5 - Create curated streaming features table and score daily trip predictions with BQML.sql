CREATE OR REPLACE TABLE `mgmt-467-project-1.bike_curated.weather_forecast_features` AS
SELECT
  forecast_date,
  temperature_2m_max,
  temperature_2m_min,
  precipitation_sum,
  wind_speed_10m_max,
  EXTRACT(DAYOFWEEK FROM forecast_date) AS dow,
  EXTRACT(MONTH FROM forecast_date)      AS month,
  IF(EXTRACT(DAYOFWEEK FROM forecast_date) IN (1,7), 1, 0) AS is_weekend,
  ingest_timestamp     -- <-- NEW: keep the ingest time
FROM `mgmt-467-project-1.bike_raw.weather_forecast_stream`;

CREATE OR REPLACE TABLE `mgmt-467-project-1.bike_curated.trips_forecast` AS
WITH
  -- Find the most recent ingest batch
  latest_batch AS (
    SELECT
      MAX(ingest_timestamp) AS latest_ts
    FROM `mgmt-467-project-1.bike_curated.weather_forecast_features`
  ),

  -- Only keep rows from that latest ingest (this should be the current 7-day forecast)
  features AS (
    SELECT
      f.*
    FROM `mgmt-467-project-1.bike_curated.weather_forecast_features` f
    CROSS JOIN latest_batch
    WHERE f.ingest_timestamp = latest_ts
  ),

  -- Member-trips predictions
  member AS (
    SELECT
      forecast_date,
      predicted_member_trips
    FROM ML.PREDICT(
      MODEL `mgmt-467-project-1.bike_curated.bike_demand_member_model`,
      (SELECT * FROM features)
    )
  ),

  -- Casual-trips predictions
  casual AS (
    SELECT
      forecast_date,
      predicted_casual_trips
    FROM ML.PREDICT(
      MODEL `mgmt-467-project-1.bike_curated.bike_demand_casual_model`,
      (SELECT * FROM features)
    )
  )

-- Final table: weather + features + ingest_timestamp + predictions
SELECT
  f.*,  -- includes ingest_timestamp + all weather features
  m.predicted_member_trips,
  c.predicted_casual_trips,
  m.predicted_member_trips + c.predicted_casual_trips AS predicted_total_trips
FROM features f
LEFT JOIN member m USING (forecast_date)
LEFT JOIN casual c USING (forecast_date)
ORDER BY forecast_date;

