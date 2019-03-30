class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :added_at
      t.string :name, null: false
      t.string :release_date
      t.string :release_type
      t.integer :total_tracks
      t.string :img_url
      t.integer :height
      t.integer :width

      t.timestamps
    end
  end
end
