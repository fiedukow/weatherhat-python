import time

import weatherhat

sensor = weatherhat.WeatherHAT()

while True:
    sensor.update(interval=60.0)

    wind_direction_cardinal = sensor.degrees_to_cardinal(sensor.wind_direction)

    print(f"""
System temp: {sensor.device_temperature:0.2f} ℃
Temperature: {sensor.temperature:0.2f} ℃

Humidity:    {sensor.humidity:0.2f} %
Dew point:   {sensor.dewpoint:0.2f} ℃

Light:       {sensor.lux:0.2f} Lux

Pressure:    {sensor.pressure:0.2f} hPa

Wind (avg):  {sensor.wind_speed:0.2f} mph

Rain:        {sensor.rain_mm_sec:0.2f} mm/sec

Wind (avg):  {sensor.wind_direction:0.2f} degrees ({wind_direction_cardinal})

""")

    time.sleep(10.0)
