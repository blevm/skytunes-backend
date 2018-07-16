class Location < ApplicationRecord
  has_many :saved_locations
  has_many :users, through: :saved_locations
end
