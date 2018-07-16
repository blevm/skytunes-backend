class User < ApplicationRecord
  has_many :saved_locations
  has_many :locations, through: :saved_locations

  validates :username, uniqueness: true, presence: true

  def expired_token?
    (Time.now - self.updated_at) > 3300
  end
  
end
