class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :spotify_url
      t.string :image_url
      t.string :access_token
      t.string :refresh_token
      t.string :k

      t.timestamps
    end
  end
end
