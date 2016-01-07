class CreateActRecords < ActiveRecord::Migration
  def change
    create_table :act_records do |t|
      t.integer :activity_id

      t.timestamps null: false
    end
    add_index :act_records, :activity_id
  end
end
