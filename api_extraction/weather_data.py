import requests
import os
from dotenv import load_dotenv
#Load environement variables from .env file
load_dotenv()

#Get the API key from the environement
api_key = os.getenv("OPENWEATHER_API_KEY")
city = "Casablanca"
url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"

response = requests.get(url)


if response.status_code == 200:

    data = response.json()
    print(data)

    temperature = data["main"]["temp"]
    weather = data["weather"][0]["description"]
    humidity = data["main"]["humidity"]

    print(f"Temperature: {temperature} °C \nWeather: {weather} \nHumidity: {humidity}%")

else:
    print(f"Failed to retrieve data: {response.status_code}")
