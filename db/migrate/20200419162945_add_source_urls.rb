class AddSourceUrls < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :youtube_url, :string
    add_column :albums, :bandcamp_url, :string
  end
end

