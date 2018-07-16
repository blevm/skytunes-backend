class Api::V1::UsersController < ApplicationController

  def login

    params = {
      client_id: ENV['CLIENT_ID'],
      response_type: 'code',
      redirect_uri: ENV['REDIRECT_URI'],
      scope: 'playlist-modify-public user-top-read user-read-recently-played user-library-read',
      show_dialog: true
    }
    url = "https://accounts.spotify.com/authorize/"

    redirect_to `#{url}?=#{params.to_query}`

  end

  def create

    if params[:error]
      puts 'ERROR', params
      redirect_to 'http://localhost:3000/login/failure'
    else

      body = {
        grant_type: 'authorization_code',
        code: params[:code],
        redirect_uri: ENV['REDIRECT_URI'],
        client_id: ENV['CLIENT_ID']
        client_secret: ENV['CLIENT_SECRET']
      }

      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)

      auth_params = JSON.parse(auth_response.body)

    end
  end

end
