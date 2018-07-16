class ApplicationController < ActionController::API

  def self.refresh_the_token
    current_user = User.find(1)

    if current_user.expired_token?

      body = {
        grant_type: 'refresh_token',
        refresh_token: current_user.refresh_token,
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
      }

      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response.body)
      current_user.update(access_token: auth_params["access_token"])

    else
      puts "Access token still valid"
    end
  end
end
