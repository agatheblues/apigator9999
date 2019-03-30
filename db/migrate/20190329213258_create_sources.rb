class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.string :source_id, unique: true
      t.string :source
      t.timestamps
    end
  end
end
