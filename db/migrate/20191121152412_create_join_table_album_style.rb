class CreateJoinTableAlbumStyle < ActiveRecord::Migration[5.2]
  def change
    create_join_table :albums, :styles do |t|
    end
  end
end
