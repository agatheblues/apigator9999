class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.datetime :added_at, null: false
      t.string :name, null: false
      t.string :release_date
      t.string :spotify_id
      t.string :discogs_id
      t.integer :total_tracks
      t.string :img_url
      t.integer :img_height
      t.integer :img_width
      t.timestamps
    end
  end
end
