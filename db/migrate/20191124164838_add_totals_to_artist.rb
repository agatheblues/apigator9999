class AddTotalsToArtist < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :total_tracks, :integer
    add_column :artists, :total_albums, :integer
  end
end
