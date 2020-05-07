class CreateBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :batches do |t|
      t.jsonb :data, null: false, default: '{}'
      t.string :job_id
      t.timestamps
    end

    add_index(:batches, :job_id, unique: true)
  end
end
