class User < ApplicationRecord
  has_many :saved_locations
  has_many :locations, through: :saved_locations

  validates :username, uniqueness: true, presence: true

  def expired_token?
    (Time.now - self.updated_at) > 3300
  end

  def refresh_the_token

    if self.expired_token?

      body = {
        grant_type: 'refresh_token',
        refresh_token: self.refresh_token,
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
      }

      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response.body)
      self.update(access_token: auth_params["access_token"])

    else
      puts "Access token still valid"
    end
  end

end
