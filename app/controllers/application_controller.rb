class ApplicationController < ActionController::API

  def get_weather_attributes(weather)
    case weather
    when 'clear-day' || 'clear-night'
      params = {
        limit: 30,
        seed_genres: "summer,happy",
        min_danceability: 0.5,
        min_tempo: 105
      }
      return params
    when 'rain'
      params = {
        limit: 30,
        seed_genres: "rainy-day,chill",
        max_acousticness: 0.9,
        max_tempo: 105
      }
      return params
    when 'snow'
      params = {
        limit: 30,
        seed_genres: "acoustic,indie",
        min_acousticness: 0.5,
        max_tempo: 120
      }
      return params
    when 'sleet'
      params = {
        limit: 30,
        seed_genres: "alternative,jazz",
        min_valence: 0.4
      }
      return params
    when 'wind'
      params = {
        limit: 30,
        seed_genres: "soul,groove",
        min_valence: 0.4
      }
      return params
    when 'fog'
      params = {
        limit: 30,
        seed_genres: "deep-house,electronic",
      }
      return params
    when 'cloudy'
      params = {
        limit: 30,
        seed_genres: "sad,ambient",
      }
      return params
    when 'partly-cloudy-day' || 'partly-cloudy-night'
      params = {
        limit: 30,
        seed_genres: "indie,pop",
        min_danceability: 0.4
      }
      return params
    end
  end

end


#
# params = {
#   limit: 30,
#   seed_genres: "rainy-day,chill",
#   max_acousticness: 0.9,
#   max_danceability: 0.2,
#   max_energy: 0.3,
#   max_instrumentalness: 0.6,
#   max_tempo: 105,
#   max_speechiness: 0.0,
#   max_valence: 0.6
# }
