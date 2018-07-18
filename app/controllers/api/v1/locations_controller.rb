class Api::V1::LocationsController < ApplicationController

  def zip_search
    lat_long_data = get_lat_long_from_zip
    weather_data = get_current_weather_from_zip(lat_long_data)

    weather_object = {
      currently: weather_data["currently"],
      minutely: weather_data["minutely"],
      city: lat_long_data["name"]
    }

    render json: weather_object
  end

  def city_search
    lat_long_data = get_lat_long_from_city
    weather_data = get_current_weather_from_city(lat_long_data)

    weather_object = {
      currently: weather_data["currently"],
      minutely: weather_data["minutely"],
      city: lat_long_data["standard"]["city"]
    }

    render json: weather_object
  end

  private

  def get_lat_long_from_zip
    response= RestClient.get("api.openweathermap.org/data/2.5/weather?zip=#{params[:search]},us&APPID=#{ENV['WEATHER_KEY']}")

    return JSON.parse(response.body)
  end

  def get_lat_long_from_city
    response= RestClient.get("https://geocode.xyz/#{params[:search].gsub!(' ', '%20')}?json=1&region=US")

    return JSON.parse(response.body)
  end

  def get_current_weather_from_zip(latlong)
    response = RestClient.get("https://api.darksky.net/forecast/#{ENV['DS_KEY']}/#{latlong["coord"]["lat"]},#{latlong["coord"]["lon"]}")

    return JSON.parse(response.body)
  end

  def get_current_weather_from_city(latlong)
    response = RestClient.get("https://api.darksky.net/forecast/#{ENV['DS_KEY']}/#{latlong["latt"]},#{latlong["longt"]}")

    return JSON.parse(response.body)
  end

end
