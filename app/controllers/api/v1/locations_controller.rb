class Api::V1::LocationsController < ApplicationController

  def search
    lat_long_data = get_lat_long
    weather_data = get_current_weather(lat_long_data)

    weather_object = {
      currently: weather_data["currently"],
      minutely: weather_data["minutely"]
    }

    render json: weather_object
  end

  private

  def get_lat_long
    response= RestClient.get("api.openweathermap.org/data/2.5/weather?zip=#{params[:search]},us&APPID=#{ENV['WEATHER_KEY']}")

    return JSON.parse(response.body)
  end

  def get_current_weather(latlong)
    response = RestClient.get("https://api.darksky.net/forecast/#{ENV['DS_KEY']}/#{latlong["coord"]["lat"]},#{latlong["coord"]["lon"]}")

    return JSON.parse(response.body)
  end

end
