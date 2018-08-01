class Api::V1::LocationsController < ApplicationController

  def zip_search
    lat_long_data = get_lat_long_from_zip
    weather_data = get_current_weather_from_zip(lat_long_data)

    weather_object = {
      currently: weather_data["currently"],
      minutely: weather_data["minutely"],
      city: lat_long_data["name"].titleize
    }

    save_a_location(lat_long_data["name"].titleize, '', params[:search], lat_long_data["coord"]["lat"].to_s, lat_long_data["coord"]["lon"].to_s, 'zipSearch')

    render json: weather_object
  end

  def city_search
    lat_long_data = get_lat_long_from_city
    weather_data = get_current_weather_from_city(lat_long_data)

    weather_object = {
      currently: weather_data["currently"],
      minutely: weather_data["minutely"],
      city: lat_long_data["standard"]["city"].titleize
    }

    save_a_location(params[:search].gsub('%20',' ').split(',')[0] || lat_long_data["standard"]["city"].titleize,params[:search].gsub('%20',' ').split(',')[1] || '', '', lat_long_data["latt"], lat_long_data["longt"], 'citySearch')

    render json: weather_object
  end

  def current_search
    lat_long_data = get_city_from_lat_long
    weather_data = get_current_weather_from_city(lat_long_data)

    weather_object = {
      currently: weather_data["currently"],
      minutely: weather_data["minutely"],
      city: lat_long_data["city"].titleize
    }

    # save_a_location(lat_long_data["city"].titleize,lat_long_data["state"],lat_long_data["postal"].split('-')[0], lat_long_data["latt"], lat_long_data["longt"], 'currentSearch')

    render json: weather_object
  end

  def intl_search
    lat_long_data = get_lat_long_from_place
    weather_data = get_current_weather_from_city(lat_long_data)

    weather_object = {
      currently: weather_data["currently"],
      minutely: weather_data["minutely"],
      city: lat_long_data["standard"]["city"].titleize
    }

    save_a_location(lat_long_data["standard"]["city"].titleize,lat_long_data["standard"]["countryname"].titleize,'', lat_long_data["latt"], lat_long_data["longt"], 'intlSearch')

    render json: weather_object
  end

  def save_a_location(city, state, zip, lat, long, search)
    id = decoded_token[0]['id']
    @user = User.find_by(id: id)

    @location = Location.find_or_create_by(city: city, state: state, zip: zip, lat: lat, long: long, search_type: search)

    @user.locations << @location
  end

  def user_locations
    id = decoded_token[0]['id']
    @user = User.find_by(id: id)

    render json: @user.locations
  end

  def delete_user_locations
    user_id = decoded_token[0]['id']
    @user = User.find_by(id: user_id)

    @location = @user.saved_locations.find_by(location_id: params[:id])

    deleted_location = @location.destroy

    render json: deleted_location
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

  def get_city_from_lat_long
    response= RestClient.get("https://geocode.xyz/#{params[:lat]},#{params[:long]}?json=1")

    return JSON.parse(response.body)
  end

  def get_lat_long_from_place
    response= RestClient.get("https://geocode.xyz/#{params[:search].gsub!(' ', '%20')}?json=1")

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
