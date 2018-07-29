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

    redirect_to "#{url}?#{params.to_query}"
  end

  def create
    if params[:error]
      puts 'ERROR', params
      redirect_to 'http://localhost:3000/login/failure'
    else
      auth_params = get_auth(params[:code])

      header = {Authorization: "Bearer #{auth_params["access_token"]}"}
      user_params = get_user_details(header)
      artists_params = get_top_artists(header)
      tracks_params = get_top_tracks(header)

      @user = User.find_or_create_by(username: user_params["id"],
                      spotify_url: user_params["external_urls"]["spotify"],
                      image_url: user_params["images"][0]["url"])

      @user.update(access_token:auth_params["access_token"], refresh_token: auth_params["refresh_token"])

      @user.artists.destroy_all
      @user.tracks.destroy_all

      artists_params["items"].each do |artist|
        @user.artists << Artist.create(spotify_id: artist["id"])
      end

      tracks_params["items"].each do |track|
        @user.tracks << Track.create(spotify_id: track["id"])
      end

      url="http://localhost:3000/success/"
      params={
        username: @user.username,
        image: @user.image_url
      }

      redirect_to "#{url}?#{params.to_query}"
    end
  end

  def get_recommended_tracks
    @user = User.find_by(username: params[:username])
    @user.refresh_the_token

    header = {Authorization: "Bearer #{@user["access_token"]}"}

    additional_params = get_weather_attributes(params[:weather])

    rec_response = RestClient.get("https://api.spotify.com/v1/recommendations/?type=tracks&seed_artists=#{@user.artists.first(3).map{|artist|artist.spotify_id}.join(',')}&#{additional_params.to_query}", header)
    rec_params = JSON.parse(rec_response.body)

    render json: rec_params
  end

  def get_more_recommended_tracks
    @user = User.find_by(username: params[:username])
    @user.refresh_the_token

    header = {Authorization: "Bearer #{@user["access_token"]}"}

    additional_params = get_weather_attributes(params[:weather])

    rec_response = RestClient.get("https://api.spotify.com/v1/recommendations/?type=tracks&seed_artists=#{@user.tracks.first(3).map{|artist|artist.spotify_id}.join(',')}&#{additional_params.to_query}", header)
    rec_params = JSON.parse(rec_response.body)

    render json: rec_params
  end

  def get_seed_genres
    @user = User.find_by(username: params[:username])
    @user.refresh_the_token

    header = {Authorization: "Bearer #{@user["access_token"]}"}

    genre_response = RestClient.get("https://api.spotify.com/v1/recommendations/available-genre-seeds", header)
    genre_params = JSON.parse(genre_response.body)

    render json: genre_params
  end

  def new_playlist
    @user = User.find_by(username: params[:username])
    @user.refresh_the_token

    playlist_body = {
      name: params[:title],
      public: true,
      collaborative: false,
      description: 'playlist created by sky tunes',
    }

    playlist_response = RestClient::Request.execute(
      method: :post,
      url: "https://api.spotify.com/v1/users/#{@user.username}/playlists",
      payload: playlist_body.to_json,
      headers: {
        "Authorization" => "Bearer #{@user["access_token"]}",
        content_type: 'application/json'
        }
      )
    playlist_params = JSON.parse(playlist_response.body)

    track_body = {"uris": JSON.parse(request.body.string)['songs'].split(',')}

    add_tracks_response = RestClient::Request.execute(method: :post,url: "https://api.spotify.com/v1/users/#{@user.username}/playlists/#{playlist_params["id"]}/tracks",payload: track_body.to_json,headers: {"Authorization" => "Bearer #{@user["access_token"]}",content_type: 'application/json'})

    # redirect_to playlist_params['external_urls']['spotify']
  end

  def logout
    @user = User.find_by(username: params[:username])

    @user.update(access_token:'', refresh_token: '')

    redirect_to 'http://localhost:3000/'
  end

  private

  def get_auth(code)
    body = {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: ENV['REDIRECT_URI'],
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET']
    }

    auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
    return JSON.parse(auth_response.body)
  end

  def get_user_details(header)
    user_response = RestClient.get('https://api.spotify.com/v1/me', header)
    return JSON.parse(user_response.body)
  end

  def get_top_artists(header)
    artists_response = RestClient.get('https://api.spotify.com/v1/me/top/artists?limit=5', header)
    return JSON.parse(artists_response.body)
  end

  def get_top_tracks(header)
    tracks_response = RestClient.get('https://api.spotify.com/v1/me/top/tracks?limit=5', header)
    return JSON.parse(tracks_response.body)
  end

end
