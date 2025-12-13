import os
import json
import datetime as dt

import functions_framework
import requests
from google.cloud import pubsub_v1

# Project + topic config
PROJECT_ID = "mgmt-467-project-1"  
TOPIC_ID = os.environ.get("TOPIC_ID", "citibike-weather-topic")


# NYC coordinates and timezone
LAT = 40.7128
LON = -74.0060
TIMEZONE = "America/New_York"

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(PROJECT_ID, TOPIC_ID)


def fetch_forecast():
    """Call Open-Meteo forecast API for the next 7 days."""
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": LAT,
        "longitude": LON,
        "daily": ",".join([
            "temperature_2m_max",
            "temperature_2m_min",
            "precipitation_sum",
            "wind_speed_10m_max",
        ]),
        "temperature_unit": "fahrenheit",
        "wind_speed_unit": "mph",
        "precipitation_unit": "inch",
        "timezone": TIMEZONE,
        "forecast_days": 7,
    }
    resp = requests.get(url, params=params, timeout=30)
    resp.raise_for_status()
    return resp.json()


@functions_framework.http
def publish_forecast(request):
    """HTTP function: fetch forecast and publish one Pub/Sub message per day."""
    data = fetch_forecast()
    daily = data["daily"]
    times = daily["time"]

    now = dt.datetime.utcnow().isoformat(timespec="seconds") + "Z"
    futures = []

    for i, forecast_date in enumerate(times):
        payload = {
            "ingest_timestamp": now,
            "forecast_date": forecast_date,
            "temperature_2m_max": daily["temperature_2m_max"][i],
            "temperature_2m_min": daily["temperature_2m_min"][i],
            "precipitation_sum": daily["precipitation_sum"][i],
            "wind_speed_10m_max": daily["wind_speed_10m_max"][i],
            "source": "open-meteo-forecast",
        }
        message_bytes = json.dumps(payload).encode("utf-8")
        futures.append(publisher.publish(topic_path, message_bytes))

    for f in futures:
        f.result()

    return f"Published {len(futures)} forecast messages at {now}\n"

