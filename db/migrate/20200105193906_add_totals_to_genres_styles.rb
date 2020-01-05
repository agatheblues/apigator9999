class AddTotalsToGenresStyles < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :total_albums, :integer, default: 0
    add_column :styles, :total_albums, :integer, default: 0
  end
end
