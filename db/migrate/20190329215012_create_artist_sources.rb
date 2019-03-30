class CreateArtistSources < ActiveRecord::Migration[5.2]
  def change
    create_join_table :sources, :artists do |t|
    end
  end
end
