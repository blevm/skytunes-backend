class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :spotify_id
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
