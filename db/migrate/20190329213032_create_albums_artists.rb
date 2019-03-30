class CreateAlbumsArtists < ActiveRecord::Migration[5.2]
  def change
    create_join_table :artists, :albums do |t|
    end
  end
end
