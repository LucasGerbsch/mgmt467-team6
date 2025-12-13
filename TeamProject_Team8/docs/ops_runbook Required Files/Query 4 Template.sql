CREATE OR REPLACE TABLE `ProjectIDPlaceholder.bike_raw.weather_forecast_stream` (
  forecast_date        DATE,
  temperature_2m_max   FLOAT64,
  temperature_2m_min   FLOAT64,
  precipitation_sum    FLOAT64,
  wind_speed_10m_max   FLOAT64,
  ingest_timestamp     TIMESTAMP,
  source               STRING
);