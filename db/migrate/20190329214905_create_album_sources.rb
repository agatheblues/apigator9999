class CreateAlbumSources < ActiveRecord::Migration[5.2]
  def change
    create_join_table :sources, :albums do |t|
    end
  end
end
