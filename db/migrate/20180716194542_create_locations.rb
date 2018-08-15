class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :city
      t.string :state
      t.string :zip
      t.string :lat
      t.string :long
      t.string :search_type

      t.timestamps
    end
  end
end
