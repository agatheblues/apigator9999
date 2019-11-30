class AddTotalsToArtist < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :total_tracks, :integer, default: 0
    add_column :artists, :total_albums, :integer, default: 0
  end
end
