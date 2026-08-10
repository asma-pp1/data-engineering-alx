# AccuWeather API Data Collector

A Python script that retrieves current weather data from the
AccuWeather API and saves them to a CSV file. Built as part of the
ALX Data Engineering programme (Storing Big Data module).

## What it does

- Calls the AccuWeather Current Conditions API for a chosen location
- Decodes the JSON response
- Extracts the observation time, weather description, temperature,
  and RealFeel temperature
- Appends each reading to `weather.csv`, writing a header row on first run

## Setup

You need your own AccuWeather API key, available free from
https://developer.accuweather.com

1. Create a file called `config.py` in the project folder
2. Add your key to it:

```python
   API_KEY = "your-key-here"
```

3. Set `LOCATION_ID` in `api_exercise.py` to your chosen location.
   You can find the ID at the end of the URL for your city on
   accuweather.com

## Running it

Note: `config.py` and `weather.csv` are excluded from version control.