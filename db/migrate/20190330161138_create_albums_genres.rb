class CreateAlbumsGenres < ActiveRecord::Migration[5.2]
  def change
    create_join_table :albums, :genres do |t|
    end
  end
end
