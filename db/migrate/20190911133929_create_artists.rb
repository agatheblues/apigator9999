class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.string :name, null: false
      t.string :img_url
      t.string :spotify_id
      t.string :discogs_id
      t.timestamps
    end

    add_index(:artists, :spotify_id, unique: true)
    add_index(:artists, :discogs_id, unique: true)
  end
end
