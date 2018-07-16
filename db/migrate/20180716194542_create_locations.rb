class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :city
      t.string :state
      t.integer :zip
      t.decimal :lat
      t.decimal :long

      t.timestamps
    end
  end
end
