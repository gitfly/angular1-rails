class CreateActivityCodes < ActiveRecord::Migration
  def change
    create_table :activity_codes, :force => true  do |t|
      t.integer :activity_id
      t.string :code
      t.integer :customer_id

      t.timestamps null: false
    end
    add_index :activity_codes, :activity_id
    add_index :activity_codes, :customer_id
  end
end
