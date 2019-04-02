class CreateAlbumSources < ActiveRecord::Migration[5.2]
  def change
    create_table :album_sources do |t|
      t.string :source_id, unique: true
      t.string :source
      t.references :album, foreign_key: true
      t.timestamps
    end
  end
end
