class CreateStyles < ActiveRecord::Migration[5.2]
  def change
    create_table :styles do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index(:styles, :name, unique: true)
  end
end
