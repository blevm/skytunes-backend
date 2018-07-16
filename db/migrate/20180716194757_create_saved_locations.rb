class CreateSavedLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :saved_locations do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
  end
end
