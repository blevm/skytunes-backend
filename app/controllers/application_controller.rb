class ApplicationController < ActionController::API

  def get_weather_attributes(weather)
    case weather
    when 'clear-day'
      params = {
        limit: 30,
        seed_genres: "summer,happy",
        min_danceability: 0.5,
        min_tempo: 105
      }
      return params
    when 'clear-night'
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
        seed_genres: "rainy-day,jazz",
        max_acousticness: 0.9,
        max_tempo: 80
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
    when 'partly-cloudy-day'
      params = {
        limit: 30,
        seed_genres: "indie,pop",
        min_danceability: 0.4
      }
      return params
    when 'partly-cloudy-night'
      params = {
        limit: 30,
        seed_genres: "indie,pop",
        min_danceability: 0.4
      }
      return params
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

########## AUTH ##########

def secret_key
   ENV['SECRET_KEY']
 end

 def authorization_token
   request.headers["Authorization"]
 end

 def decoded_token
   begin
     JWT.decode authorization_token(), secret_key(), true, { algorithm: 'HS256' }
   rescue JWT::VerificationError, JWT::DecodeError
     nil
   end
 end

 def valid_token?
   !!decoded_token
 end

 def requires_login
   if !valid_token?
     render json: {
       message: 'You must log in to access this information.'
     }, status: :unauthorized
   end
 end

 def payload(name, id)
   { name: name, id: id }
 end

 def get_token(payload)
   JWT.encode payload, secret_key(), 'HS256'
 end

end
